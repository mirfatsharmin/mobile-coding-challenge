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
    func collectionViewWillMove(at indexPath:IndexPath?)
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
        
        fetchDataWhenApplicationEnterForeground()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.collectionView?.collectionViewLayout.invalidateLayout()
            strongSelf.collectionView?.reloadData()
            }, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.collectionView?.reloadData()
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController:PhotoDetailCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailCollectionViewController") as! PhotoDetailCollectionViewController
        viewController.selectedIndexPath = indexPath
        viewController.collectionViewScrollToIndexDelegate = self
        navigationController?.present(viewController, animated: true, completion: {
            
        })
        
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
    
    func collectionViewWillMove(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        collectionView?.layoutIfNeeded()
        collectionView?.reloadData()
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
    }
}

//MARK: Handing data fetching when app comes from background
extension PhotoGridViewController {
    fileprivate func fetchDataWhenApplicationEnterForeground() {
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: .main) { [weak self] notification in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.fetchPhotosIfNeeded(for: 0)
        }
    }
}
