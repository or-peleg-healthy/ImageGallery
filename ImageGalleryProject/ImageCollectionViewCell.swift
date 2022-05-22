//
//  ImageCollectionViewCell.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    func configure(with countryName: String) {
        label.text = countryName
    }
}
