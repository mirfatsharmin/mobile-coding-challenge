//
//  DataManager.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import Foundation


class DataManager{
    
    static let sharedDataManager = DataManager()
    private var photosUniqueDictionaryById = [String: Photo]()
    
    
    // MARK: Fetch Data from API
    private var unsplashApiClient: UnsplashApiClient<Photo>
    init(apiClient: UnsplashApiClient<Photo> = UnsplashApiClient<Photo>()) {
        unsplashApiClient = apiClient
    }
    
    func fetchCuratedPhotos(completionHandler: @escaping ([Photo]) -> Void){
        unsplashApiClient.requestCuratedPhotos() { (photos) in
            DataManager.sharedDataManager.savePhotos(photos: photos)
            completionHandler(photos)
        }
    }
    
}

// MARK: Save Photos in DataManager
extension DataManager {
    var photoList: [Photo] {
        return Array(photosUniqueDictionaryById.values)
    }
    
    private func savePhotos(photos: [Photo]) {
        for photo in photos {
            photosUniqueDictionaryById[photo.id] = photo
        }
    }
}
