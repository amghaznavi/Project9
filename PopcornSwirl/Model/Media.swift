//
//  Media.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 30/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit

protocol Identifiable {
    var mediaId: String? { get set }
}

class MediaBrief: Codable, Identifiable {
    var mediaId: String? = nil
    
    var id: Int
    var title: String
    var releaseDate: String?
    var description: String?
    var shortDescription: String?
    var genre: String?
    var mediaUrl: String?
    var artworkUrl: String?
    var artworkData: Data?
    var note: String = ""
    var bookmark: Bool = false
    var watched: Bool = false
    
    init(id: Int, title: String, description: String, shortDescription: String, genre: String,  releaseDate: String, mediaUrl: String, artworkUrl: String) {
        
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.description = description
        self.shortDescription = shortDescription
        self.genre = genre
        self.artworkUrl = artworkUrl
        self.mediaUrl = mediaUrl
    }
    
    
}
