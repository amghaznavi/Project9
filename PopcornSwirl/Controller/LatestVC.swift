//
//  LatestVC.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 29/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LatestVC : UIViewController {
    
    var indexPath: IndexPath!
    var collectionViewDelegate: UICollectionView!
    var filteredDataSource: [MediaBrief] = []
    var interstitial: GADInterstitial?
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var CollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        CollectionView.collectionViewLayout = configureLayout()
        loadData()
        DataManager.store()
        //Google AdMOB - Ads
//        interstitial = createAndLoadInterstitial()
        CollectionView.delegate = self
        CollectionView.dataSource = self
        // Register custom cell
        CollectionView.register(UINib(nibName: Constants.latestVCCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.latestVCCollectionViewCellID)
    }
    
    var dataSource: [MediaBrief] {
        return DataManager.shared.mediaList
    }
    
    func loadData() {
         FIRFirestoreService.shared.read(from: .media, returning: MediaBrief.self) { (movies) in
             DataManager.shared.mediaList.removeAll()
             DataManager.shared.mediaList = movies
             self.filteredDataSource = self.dataSource
         }
     }
    
    // Configure cell size
    func configureLayout() -> UICollectionViewCompositionalLayout {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      
      return UICollectionViewCompositionalLayout(section: section)
    }
    

}


// MARK: - Collection view delegate
extension LatestVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.latestVCCollectionViewCellID, for: indexPath) as! LatestVCCollectionViewCell
        
        let mediaBrief = dataSource[indexPath.item]
        cell.delegate = self
        cell.delegate?.collectionViewDelegate = collectionView
        cell.delegate?.indexPath = indexPath
        cell.populate(mediaBrief: mediaBrief)
        DataManager.checkIfWatched(id: mediaBrief.id, selectWatchedButton: cell.SelectWatchedButton, addToWatchedLabel: cell.AddToWatchedLabel)
        DataManager.checkIfBookmarked(id: mediaBrief.id, selectBookmarkButton: cell.SelectBookmarButton, addToBookmarkLabel: cell.AddToBookmarkLabel)
        return cell
    }
}



extension LatestVC: UICollectionViewDelegate {
}

//MARK:- Google AdMOB - Interstitial Ads
extension LatestVC: GADInterstitialDelegate {
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        guard let interstitial = interstitial else {
            return nil
        }
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        return interstitial
    }
    
    func presentNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Got it", style: .cancel, handler: { (action) -> Void in
        })
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }

}
