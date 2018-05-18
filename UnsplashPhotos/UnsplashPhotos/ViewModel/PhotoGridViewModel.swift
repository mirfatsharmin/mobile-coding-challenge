//
//  PhotoCollectionViewModel.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import Foundation

typealias ReloadViewClosure = (_ success: Bool, _ error: NSError?) -> Void

class PhotoGridViewModel {
    
    var reloadViewClosure: ReloadViewClosure?
    
    var numberOfCells: Int {
        return DataManager.sharedDataManager.photoList.count
    }
    
    func createCellViewModel( photo: Photo ) -> PhotoGridCellViewModel? {
        return PhotoGridCellViewModel(photo: photo)
    }
    
    func getCellViewModel( at index: Int ) -> PhotoGridCellViewModel? {
        return createCellViewModel(photo: DataManager.sharedDataManager.photoList[index])
    }
}

//MARK: FetchPhotos from network at initial stage or before last few cells
extension PhotoGridViewModel {
    func fetchPhotosIfNeeded(for index:Int) {
        guard self.numberOfCells == 0 || index == self.numberOfCells - 1 else {
            return
        }
        DataManager.sharedDataManager.fetchCuratedPhotos() {[weak self] photos in
            DispatchQueue.main.async {
                self?.reloadViewClosure?(true, nil)
            }
        }
        
    }
    
}
