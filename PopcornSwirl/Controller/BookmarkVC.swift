//
//  BookmarkVC.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 29/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BookmarkVC : UIViewController {
    
    var collectionViewDelegate: UICollectionView!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var CollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DataManager.loadBookmarkedMovie(collectionView: CollectionView)
    }
    
    func configure() {
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.collectionViewLayout = configureLayout()
        // Register custom cell
        CollectionView.register(UINib(nibName: Constants.bookmarkVCCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.bookmarkVCCollectionViewCellID)
    }
    
    var dataSource: [MediaBrief] {
        return DataManager.shared.bookmarkedList
     }
    
    // Configure cell size
    func configureLayout() -> UICollectionViewCompositionalLayout {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      
      return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    
}




// MARK: - Collection view delegate
extension BookmarkVC: UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.bookmarkVCCollectionViewCellID, for: indexPath) as! BookmarkVCCollectionViewCell
        
        let mediaBrief = dataSource[indexPath.item]
        
        cell.delegate = self
        cell.delegate?.collectionViewDelegate = collectionView
        cell.populate(mediaBrief: mediaBrief)
        if mediaBrief.note.count > 0 {
                   cell.NoteLabel.text = mediaBrief.note
               } else {
                   cell.NoteLabel.text = "write your note here..."
               }
        DataManager.checkIfWatched(id: cell.id, selectWatchedButton: cell.SelectWatchedButton, addToWatchedLabel: cell.AddToWatchedLabel)
        
        return cell
    }
    
    
}

extension BookmarkVC: UICollectionViewDelegate {
}

