//
//  ImageCollectionViewCell.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    func configure(with imageURL: URL) {
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.spinner.startAnimating()
                var image = UIImage(data: urlContents!)
                self.cellView.image = image
                self.cellView.sizeToFit()
                self.sizeToFit()
            }
        }
    }
}
