//
//  Photo.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let id: String
    let width: Float?
    let height: Float?
    let photoUrls: PhotoUrls?
    let likes: Int?
    let publisher: Publisher?
    let publishedOn: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case photoUrls = "urls"
        case likes
        case publisher = "user"
        case publishedOn = "created_at"
    }
    
    struct PhotoUrls:Codable {
        let raw: URL?
        let full: URL?
        let regular: URL?
        let small: URL?
        let thumb: URL?
        
        private enum CodingKeys: String, CodingKey {
            case raw
            case full
            case regular
            case small
            case thumb
        }
    }
}
