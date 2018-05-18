//
//  PhotoGridCellViewModel.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import Foundation

struct PhotoGridCellViewModel {
    let id: String
    let photoUrl: URL
    let dimensionWidth:Float
    let dimensionHeight: Float
    
    init?(photo: Photo)  {
        let imageUrl = photo.photoUrls?.regular ?? photo.photoUrls?.raw ?? photo.photoUrls?.thumb ?? photo.photoUrls?.small
        if let imageUrl = imageUrl {
            self.id = photo.id
            self.photoUrl = imageUrl
            self.dimensionWidth = photo.width ?? 50.0
            self.dimensionHeight = photo.height ?? 50.0
        } else {
            return nil
        }
    }
}
