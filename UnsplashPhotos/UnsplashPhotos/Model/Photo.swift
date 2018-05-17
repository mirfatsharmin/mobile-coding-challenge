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
    let likes: Int?
    let publishedOn: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case likes
        case publishedOn = "created_at"
        
    }
}
