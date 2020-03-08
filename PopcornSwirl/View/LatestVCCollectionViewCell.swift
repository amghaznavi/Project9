//
//  LatestVCCollectionViewCell.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 30/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit


protocol LatestVCCellDelegate {
    var collectionViewDelegate : UICollectionView! { get set }
    var indexPath: IndexPath! {get set}
}

class LatestVCCollectionViewCell: UICollectionViewCell {
    
    var id = Int()
    var delegate: LatestVCCellDelegate?
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var ArtworkImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var Genre: UILabel!
    @IBOutlet weak var ReleaseDate: UILabel!
    @IBOutlet weak var ShortDescription: UILabel!
    @IBOutlet weak var AddToWatchedLabel: UILabel!
    @IBOutlet weak var SelectWatchedButton: UIButton!
    @IBOutlet weak var AddToBookmarkLabel: UILabel!
    @IBOutlet weak var SelectBookmarButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func onAddBookmarkButton(_ sender: Any) {
        DataManager.bookmarkButtonPressed(id: id, bookmarkButton: SelectBookmarButton, bookmarkLabel: AddToBookmarkLabel, collectionView: delegate!.collectionViewDelegate)
    }
    
    @IBAction func onSelectWatchedButton(_ sender: Any) {
        DataManager.watchButtonPressed(id: id, watchedButton: SelectWatchedButton, watchedLabel: AddToWatchedLabel, collectionView: delegate!.collectionViewDelegate)
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
    
    @IBAction func onMoreBtn(_ sender: Any) {
        MediaService.moreBtnPressed(movieId: id)
    }
    
    
}


extension LatestVC : LatestVCCellDelegate  {
    
}






