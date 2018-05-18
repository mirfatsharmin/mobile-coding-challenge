//
//  PhotoGridViewController.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 17/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoGridCell"

protocol CollectionViewScroll: class {
    func collectionViewWillMove(at index:Int)
}

class PhotoGridViewController: UICollectionViewController {
    
    lazy var viewModel: PhotoGridViewModel = {
        return PhotoGridViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        initViewModel()
        viewModel.fetchPhotosIfNeeded(for: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.collectionView?.collectionViewLayout.invalidateLayout()
            }, completion: nil)
    }
    
}

//MARK: Helper
extension PhotoGridViewController {
    private  func initLayout() {
        if let layout = collectionView?.collectionViewLayout as? GridFlowLayout {
            layout.delegate = self
        }
    }
    
    private  func initViewModel() {
        // Naive binding
        viewModel.reloadViewClosure = { [weak self] (success, error) in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension PhotoGridViewController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoGridViewCell
        // Configure the cell
        if let photoCellViewModel = viewModel.getCellViewModel(at: indexPath.row) {
            cell.imageUrl = photoCellViewModel.photoUrl
        }
        viewModel.fetchPhotosIfNeeded(for: indexPath.row)
        return cell
    }
}

//MARK: Layout Delegate
extension PhotoGridViewController : GridLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        // photo height
        let photo = viewModel.getCellViewModel(at: indexPath.row)
        return CGSize(width: CGFloat(photo?.dimensionWidth ?? 0.0), height: CGFloat(photo?.dimensionHeight ?? 0.0))
        
    }
}

//MARK: CollectionViewScroll Delegate
extension PhotoGridViewController: CollectionViewScroll {
    
    func collectionViewWillMove(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView?.layoutIfNeeded()
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
    }
}
