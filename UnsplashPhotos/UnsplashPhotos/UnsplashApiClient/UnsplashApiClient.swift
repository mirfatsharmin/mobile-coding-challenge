//
//  UnsplashApiClient.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import Foundation
import Alamofire

fileprivate enum Constants {
    static let itemsPerPage = 10
}

struct UnsplashApiClient<Element:Codable> {
    
    private var currentPage: Int = 0
    
    @discardableResult
    private func performRequest(route:URLRequestConvertible, completion:@escaping (Array<Element>)->Void) -> DataRequest {
        return Alamofire.request(route)
            .responseJSON(completionHandler: { (response) in
                guard response.result.isSuccess,
                    let data = response.data else {
                        print("Error while fetching data: \(String(describing: response.result.error))")
                        return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let output = try? decoder.decode(Array<Element>.self, from: data)
                if let output = output {
                    completion(output)
                }
            })
    }
    
    mutating func requestCuratedPhotos(itemsPerPage:Int = Constants.itemsPerPage, completion:@escaping (Array<Element>)->Void) {
        currentPage = currentPage + 1
        
        requestCuratedPhotos(for: currentPage, itemsPerPage: itemsPerPage, completion: completion)
    }
    
    private func requestCuratedPhotos(for page:Int, itemsPerPage:Int, completion:@escaping (Array<Element>)->Void) {
        performRequest(route: UnsplashApiConfiguration.curatedPhotoList(page: page, itemsPerPage: itemsPerPage), completion: completion)
    }
}
