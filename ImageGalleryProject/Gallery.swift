//
//  Gallery.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import Foundation

class Gallery {
    var name: String
    var images: [WebImage]
    var width: Double
    
    init(name: String) {
        self.name = name
        images = []
        width = 0
    }
}
