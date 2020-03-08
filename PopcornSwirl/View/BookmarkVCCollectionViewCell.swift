//
//  BookmarkVCCollectionViewCell.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 30/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit


protocol BookmarkVCCellDelegate {
    func removeFromBookmark(_ cell: BookmarkVCCollectionViewCell)
    func addNote(_ cell: BookmarkVCCollectionViewCell)
    var collectionViewDelegate : UICollectionView! { get set }
}


class BookmarkVCCollectionViewCell: UICollectionViewCell {
    
    var id = Int()
    var delegate: BookmarkVCCellDelegate?
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var ArtworkImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DetailLabel: UILabel!
    @IBOutlet weak var Genre: UILabel!
    @IBOutlet weak var ReleaseDate: UILabel!
    @IBOutlet weak var NoteLabel: UILabel!
    @IBOutlet weak var NoteButton: UIButton!
    @IBOutlet weak var AddToWatchedLabel: UILabel!
    @IBOutlet weak var SelectWatchedButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onSelectWatchedBtn(_ sender: Any) {
        DataManager.watchButtonPressed(id: id, watchedButton: SelectWatchedButton, watchedLabel: AddToWatchedLabel, collectionView: delegate!.collectionViewDelegate)
    }
    @IBAction func onRemoveBtn(_ sender: Any) {
        delegate?.removeFromBookmark(self)
    }
    
    @IBAction func onMoreBtn(_ sender: Any) {
        MediaService.moreBtnPressed(movieId: id)
    }
    
    @IBAction func onCommentBtn(_ sender: Any) {
        delegate?.addNote(self)
    }
    
    // Populate  collectionView cell
    func populate(mediaBrief: MediaBrief) {
        TitleLabel.text = mediaBrief.title
        DetailLabel.text = mediaBrief.description
        ReleaseDate.text = mediaBrief.releaseDate
        Genre.text = mediaBrief.genre
        if let imageURL = URL(string: mediaBrief.artworkUrl!) {
            MediaService.getImage(imageUrl: imageURL, completion: { (success, imageData) in
                if success, let imageData = imageData,
                    let artwork = UIImage(data: imageData) {
                    mediaBrief.artworkData = imageData
                    DispatchQueue.main.async {
                        self.ArtworkImageView.image = artwork
                    }
                }
            })
        }
        id = mediaBrief.id
    }
}





extension BookmarkVC : BookmarkVCCellDelegate {
    
    func removeFromBookmark(_ cell: BookmarkVCCollectionViewCell) {
        let movieToRemove = DataManager.shared.mediaList.filter({$0.id == cell.id}).first
        if let movie = movieToRemove {
            movie.bookmark = false
            FIRFirestoreService.shared.update(for: movie, in: .media)
            DataManager.loadBookmarkedMovie(collectionView: CollectionView)
        }
    }
    
    
    func addNote(_ cell: BookmarkVCCollectionViewCell) {
        DataManager.commentButtonPressed(vc: self, movieId: cell.id, noteLabel: cell.NoteLabel)
        CollectionView.reloadData()
    }
}
