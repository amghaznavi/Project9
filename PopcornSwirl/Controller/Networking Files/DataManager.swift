//
//  DataManager.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 30/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit
import Firebase

class DataManager {
    
    static let shared = DataManager()
    
    private init() {
    }
    
    lazy var mediaList: [MediaBrief] = {
        var list = [MediaBrief]()
        
        for i in 0 ..< 100 {
            let media = MediaBrief(id: 486040195,
                                   title: "fakeTitle \(i)", description: "Long description", shortDescription: "", genre: "Comedy", releaseDate: "2020", mediaUrl: "",
                                   artworkUrl: "https://is4-ssl.mzstatic.com/image/thumb/Music/v4/33/ed/8e/33ed8eb0-4768-c14a-7e21-c421b9647e09/source/100x100bb.jpg")
            list.append(media)
        }
        
        return list
    } ()
    
    
    lazy var bookmarkedList: [MediaBrief] = {
        var list = [MediaBrief]()
        
        return list
    }()
    
    lazy var watchedList: [MediaBrief] = {
        var list = [MediaBrief]()
        
        return list
    }()
    
    static func store() {
        MediaService.getMovieList(term: Constants.search ) { (success, list) in
            if success, let list = list {
                let ready = list.sorted(by: { $0.releaseDate!.compare($1.releaseDate!) == .orderedDescending })
                FIRFirestoreService.shared.read(from: .media, returning: MediaBrief.self) { (existingMovies) in
                    for movie in ready {
                        guard !existingMovies.contains(where: {movie.id == $0.id}) else { return }
                        FIRFirestoreService.shared.create(for: movie, in: .media)
                    }
                }
            } else {
                print("Couldn't load any fun stuff for you:(")
            }
        }
    }
    
    
    static func loadBookmarkedMovie(collectionView: UICollectionView?) {
        DataManager.shared.bookmarkedList = DataManager.shared.mediaList.filter({$0.bookmark == true})
        if (collectionView != nil) {
            DispatchQueue.main.async {
                collectionView?.reloadData()
            }
        }
    }
    
    
    static func loadWatchedMovie(collectionView: UICollectionView?) {
        DataManager.shared.watchedList = DataManager.shared.mediaList.filter({$0.watched == true})
        if (collectionView != nil) {
            DispatchQueue.main.async {
                collectionView?.reloadData()
            }
        }
    }

    @discardableResult
    static func checkIfBookmarked(id: Int, selectBookmarkButton: UIButton, addToBookmarkLabel: UILabel ) -> Bool {
        var result = true
        let movie = DataManager.shared.mediaList.filter({$0.id == id})
        if movie.first?.bookmark == true {
            selectBookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            addToBookmarkLabel.text = "BOOKMARKED"
            result = true
        } else {
            selectBookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            addToBookmarkLabel.text = "ADD TO BOOKMARK"
            result = false
        }
        return result
    }
    
    static func bookmarkButtonPressed(id: Int, bookmarkButton: UIButton, bookmarkLabel: UILabel, collectionView: UICollectionView) {
        if checkIfBookmarked(id: id, selectBookmarkButton: bookmarkButton, addToBookmarkLabel: bookmarkLabel) {
            return
        } else {
            let movieBookmarked = DataManager.shared.mediaList.filter({$0.id == id}).first
            if let movie = movieBookmarked {
                movie.bookmark = true
                FIRFirestoreService.shared.update(for: movie, in: .media)
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    
    
    @discardableResult
    static func checkIfWatched(id: Int, selectWatchedButton: UIButton, addToWatchedLabel: UILabel ) -> Bool {
        var result = true
        let movie = DataManager.shared.mediaList.filter({$0.id == id})
        if movie.first?.watched == true {
            selectWatchedButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            addToWatchedLabel.text = "WATCHED"
            result = true
        } else {
            selectWatchedButton.setImage(UIImage(systemName: "star"), for: .normal)
            addToWatchedLabel.text = "ADD TO WATCHED"
            result = false
        }
        return result
    }
    
    
    static func watchButtonPressed (id: Int, watchedButton: UIButton, watchedLabel: UILabel, collectionView: UICollectionView) {
        if checkIfWatched(id: id, selectWatchedButton: watchedButton, addToWatchedLabel: watchedLabel) {
            return
        } else {
            let movieWatched = DataManager.shared.mediaList.filter({$0.id == id}).first
            if let movie = movieWatched {
                movie.watched = true
                FIRFirestoreService.shared.update(for: movie, in: .media)
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    static func commentButtonPressed(vc: UIViewController, movieId: Int, noteLabel: UILabel) {
        let alertController = UIAlertController(title: "Note", message: "Enter your note for this movie!", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            if (DataManager.shared.bookmarkedList.filter({$0.id
                == movieId}).first?.note.isEmpty)! {
                textField.placeholder = "Enter your note..."
            } else {
                textField.placeholder = DataManager.shared.bookmarkedList.filter({$0.id
                    == movieId}).first?.note
            }
        }
        
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    DataManager.shared.bookmarkedList.filter({$0.id
                        == movieId}).first?.note = textField.text!
                    noteLabel.text = textField.text
                    noteLabel.textColor = .lightGray
                    let movie = DataManager.shared.mediaList.filter({$0.id == movieId}).first!
                    movie.note = textField.text!
                    FIRFirestoreService.shared.update(for: movie, in: .media)
                }
            }
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.preferredAction = saveAction
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    
}
