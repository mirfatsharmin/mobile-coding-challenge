//
//  PhotoGridViewCell.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoGridViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setOpaqueBackground()
    }
    
    var imageUrl: URL? {
        didSet {
            if let imageUrl = imageUrl {
                photoImageView.image = nil
                photoImageView.kf.indicatorType  = .activity
                photoImageView.kf.setImage(with: imageUrl)
            }
        }
    }
}

private extension PhotoGridViewCell {
    static let defaultBackgroundColor = UIColor.groupTableViewBackground
    
    func setOpaqueBackground() {
        alpha = 1.0
        backgroundColor = PhotoGridViewCell.defaultBackgroundColor
    }
}
