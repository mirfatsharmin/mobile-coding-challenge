//
//  UnsplashApiConfiguration.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import Foundation
import Alamofire

enum UnsplashApiConfiguration {
    
    case curatedPhotoList(page: Int, itemsPerPage: Int)
    
    private enum Constants {
        static let baseUrlPath = "https://api.unsplash.com"
        static let accessKey = "b9405cfb421a0aa04ce671a3c249842db5282998a2c8c8ac2eef24048ae17296"
    }
    
    private enum ParameterKey {
        static let clientId = "client_id"
        static let page = "page"
        static let itemsPerPage = "per_page"
        static let orderBy = "order_by"
    }
    
    private var path:String {
        switch self {
        case .curatedPhotoList:
            return "/photos/curated"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .curatedPhotoList:
            return .get
        }
    }
    
    private var parameters:[String:Any] {
        switch self {
        case .curatedPhotoList(let page, let itemsPerPage):
            return [ParameterKey.clientId: Constants.accessKey, ParameterKey.page: page, ParameterKey.itemsPerPage: itemsPerPage]
        }
    }
}
