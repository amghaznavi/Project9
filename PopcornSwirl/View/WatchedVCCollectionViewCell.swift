//
//  WatchedVCCollectionViewCell.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 30/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit


protocol WatchedVCCellDelegate {
    var collectionViewDelegate : UICollectionView! { get set }
    var indexPath: IndexPath! {get set}
    func removeFromWatched(_ cell: WatchedVCCollectionViewCell)
}

class WatchedVCCollectionViewCell: UICollectionViewCell {
    
    var id = Int()
    var delegate: WatchedVCCellDelegate?
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var ArtworkImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var Genre: UILabel!
    @IBOutlet weak var ReleaseDate: UILabel!
    @IBOutlet weak var ShortDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
    }
    
    // Populate  collectionView cell
    func populate(mediaBrief: MediaBrief) {
        TitleLabel.text = mediaBrief.title
        ShortDescription.text = mediaBrief.shortDescription
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
    
    @IBAction func onRemoveBtn(_ sender: Any) {
        delegate?.removeFromWatched(self)
    }
    
    @IBAction func onMoreBtn(_ sender: Any) {
        MediaService.moreBtnPressed(movieId: id)
    }
    
}


extension WatchedVC : WatchedVCCellDelegate  {
    
    func removeFromWatched(_ cell: WatchedVCCollectionViewCell) {
        let movieToRemove = DataManager.shared.mediaList.filter({$0.id == cell.id}).first
        if let movie = movieToRemove {
            movie.watched = false
            FIRFirestoreService.shared.update(for: movie, in: .media)
            DataManager.loadWatchedMovie(collectionView: CollectionView)
        }
    }
}
