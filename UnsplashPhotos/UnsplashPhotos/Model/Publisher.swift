//
//  Publisher.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import Foundation

struct Publisher:Codable {
    let id:String
    let userName:String?
    let name:String?
    let firstName:String?
    let lastName:String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
