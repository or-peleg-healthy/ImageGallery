//
//  ImagesCollectionViewController.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit


class ImagesCollectionViewController: UICollectionViewController {
    let defaultURL = URL(string: "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cg_face%2Cq_auto:good%2Cw_300/MTQ3NTI2NTg2OTE1MTA0MjM4/kenrick_lamar_photo_by_jason_merritt_getty_images_entertainment_getty_476933160.jpg")
    var gallery: Gallery?
    var chosenImageToEnlarge: WebImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100000
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCollectionViewCell {
            if gallery != nil, indexPath.item < ((gallery?.images.count)!) {
                imageCell.configure(with: ((gallery?.images[indexPath.item].imageURL) ?? defaultURL)!)
            } else {
                imageCell.blank()
            }
            cell = imageCell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenImageToEnlarge = gallery?.images[indexPath.item]
        performSegue(withIdentifier: "Show Image", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImageViewController {
            if segue.identifier == "Show Image" {
                destination.imageURL = chosenImageToEnlarge?.imageURL
            } else {
                return
            }
        }
    }
}
