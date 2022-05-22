//
//  ImagesCollectionViewController.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit


class ImagesCollectionViewController: UICollectionViewController {
    var imageURLs = [URL(string: "someURL")]
    let dataSource = ["someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL", "someURL"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let countryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCollectionViewCell {
            countryCell.configure(with: dataSource[indexPath.item])
            
            cell = countryCell
        }
        return cell
    }
}
