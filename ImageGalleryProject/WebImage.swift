//
//  WebImage.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import Foundation

struct WebImage {
    let imageURL: URL
    let aspectRatio: Double
    
    init(_ imgURL: URL, _ aspectRatio: Double) {
        self.imageURL = imgURL
        self.aspectRatio = aspectRatio
    }
}
