//
//  PhotoDetailViewModel.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 18/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import Foundation

typealias ReloadDetailViewClosure = (_ success: Bool, _ error: NSError?) -> Void

class PhotoDetailViewModel {
    
    var reloadViewClosure: ReloadDetailViewClosure?
    
    var numberOfCells: Int {
        return DataManager.sharedDataManager.photoList.count
    }
    
    func createCellViewModel( photo: Photo ) -> PhotoDetailCellViewModel? {
        return PhotoDetailCellViewModel(photo: photo)
    }
    
    func getCellViewModel( at index: Int ) -> PhotoDetailCellViewModel? {
        return createCellViewModel(photo: DataManager.sharedDataManager.photoList[index])
    }
}

//MARK: FetchPhotos from network at initial stage or before last few cells
extension PhotoDetailViewModel {
    func fetchPhotosIfNeeded(for index:Int) {
        guard numberOfCells == 0 || index == numberOfCells - 1 else {
            return
        }
        DataManager.sharedDataManager.fetchCuratedPhotos() {[weak self] photos in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.reloadViewClosure?(true, nil)
            }
        }
        
    }
    
}
