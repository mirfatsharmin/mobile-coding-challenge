//
//  PhotoDetailCellViewModel.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 18/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import Foundation
struct PhotoDetailCellViewModel{
    let id: String
    let photoUrl: URL
    var dimension:String
    let likes: String
    let publisherName: String
    let publishedOn: String
    
    
    init?(photo: Photo)  {
        let imageUrl = photo.photoUrls?.regular ?? photo.photoUrls?.raw ?? photo.photoUrls?.thumb ?? photo.photoUrls?.small
        if let imageUrl = imageUrl {
            photoUrl = imageUrl
            id = photo.id
            
            if let dimensionWidth = photo.width, let dimensionHeight = photo.height {
                dimension =  NSLocalizedString("Dimension:", comment: "") + "\n\(dimensionWidth) * \(dimensionHeight)"
            } else {
                dimension = ""
            }
            likes = NSLocalizedString("Likes:", comment: "") + "\n\(photo.likes ?? 0)"
            publisherName = photo.publisher?.name ?? photo.publisher?.firstName ?? photo.publisher?.lastName ?? NSLocalizedString("Firstname Lastname", comment: "")
            
            let publishedOnText = (photo.publishedOn?.dateAsString()) ?? ""
            publishedOn = NSLocalizedString("Published On:", comment: "") + "\n" + publishedOnText
            
        } else {
            return nil
        }
    }
}

// MARK: Date formatter Helper
fileprivate extension Date {
    fileprivate func dateAsString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: self)
        return str
    }
    
}
