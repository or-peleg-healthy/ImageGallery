//
//  ImageCollectionViewCell.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    
    func configure(with imageURL: URL) {
        let spinner = UIActivityIndicatorView(frame: cellView.frame)
        cellView.addSubview(spinner)
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                spinner.removeFromSuperview()
                self.cellView.backgroundColor = UIColor(patternImage: UIImage(data: urlContents!)!)
            }
        }
    }
}
