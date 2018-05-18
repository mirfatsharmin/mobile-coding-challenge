//
//  GridFlowLayout.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import UIKit

protocol GridLayoutDelegate: class {
    func collectionView(_ collectionView:UICollectionView, sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize
    
}

class GridFlowLayout: UICollectionViewFlowLayout {
    enum Configuration{
        static let numberOfColumns = 2
        static let cellPadding:CGFloat = 6
    }
    
    weak var delegate: GridLayoutDelegate!
    
    fileprivate var layoutAttributesCache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth:CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        layoutAttributesCache.removeAll()
        
        guard layoutAttributesCache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        
        let columnWidth = contentWidth / CGFloat(Configuration.numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< Configuration.numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: Configuration.numberOfColumns)
        
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            
            let photoSize = delegate.collectionView(collectionView, sizeForPhotoAtIndexPath: indexPath)
            let photoHeight = photoSize.height * columnWidth / photoSize.width
            let height = Configuration.cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: Configuration.cellPadding, dy: Configuration.cellPadding)
            
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutAttributesCache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (Configuration.numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in layoutAttributesCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesCache[indexPath.item]
    }
    
}
