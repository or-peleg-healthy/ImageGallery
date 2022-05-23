//
//  Gallery.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit

class Gallery {
    var name: String
    var images: [URL]
    var width: Double
    
    init(name: String) {
        self.name = name
        images = []
        width = 0
    }
}
