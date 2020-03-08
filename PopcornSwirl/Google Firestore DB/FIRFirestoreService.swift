//
//  FIRFirestoreService.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 07/02/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

enum FIRCollectionReference: String {
    case media
    case bookmarkedMedia
    case watchedMedia
}

enum MyError: Error {
    case encodingError
}

class FIRFirestoreService {
    
    private init() {}
    static let shared = FIRFirestoreService()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func create<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        do {
            let json = try encodableObject.toJson(excluding: ["\(Constants.FirestoreDB.mediaId)"])
            reference(to: collectionReference).addDocument(data: json)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, completion: @escaping([T]) -> Void) {
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else {return}
            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                completion(objects)
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
    func update<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        do {
            let json = try encodableObject.toJson(excluding: ["\(Constants.FirestoreDB.mediaId)"])
            guard let id = encodableObject.mediaId else { throw MyError.encodingError }
            reference(to: collectionReference).document(id).setData(json)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete<T: Identifiable>(_ identifiableObject: T, in collectionReference: FIRCollectionReference) {
        do {
            guard let id = identifiableObject.mediaId else { throw MyError.encodingError }
            reference(to: collectionReference).document(id).delete()
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        var documentJson = data()
        if includingId {
            documentJson!["\(Constants.FirestoreDB.mediaId)"] = documentID
        }
        let documentData = try JSONSerialization.data(withJSONObject: documentJson as Any, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        
        return decodedObject
    }
}

extension Encodable {
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String: Any] else {throw MyError.encodingError }
        
        for key in keys {
            json[key] = nil
        }
        return json
    }
}
