//
//  Constants.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 29/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import Foundation


struct Constants {
    
    static let appName = "PopcornSwirl"
    static let search = "movie"
    static let registerSegue = "registerToLatest"
    static let loginSegue = "loginToLatest"
    static let latestVCCollectionViewCell = "LatestVCCollectionViewCell"
    static let latestVCCollectionViewCellID = "LatestVCCell"
    static let bookmarkVCCollectionViewCell = "BookmarkVCCollectionViewCell"
    static let bookmarkVCCollectionViewCellID = "BookmarkVCCell"
    static let watchedVCCollectionViewCell = "WatchedVCCollectionViewCell"
    static let watchedVCCollectionViewCellID = "WatchedVCCell"
    static let cancel = "Cancel"
    
    struct FirestoreDB {
        static let bookmarked = "bookmarkedMovies"
        static let watched = "watchedMovies"
        static let user = "user"
        static let movie = "movie"
        static let note = "note"
        static let date = "date"
        static let mediaId = "mediaId"
    }
    
}
