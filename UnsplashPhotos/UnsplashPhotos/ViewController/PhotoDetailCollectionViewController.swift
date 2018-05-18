//
//  PhotoDetailCollectionViewController.swift
//  UnsplashPhotos
//
//  Created by Mirfat on 18/5/18.
//  Copyright © 2018 TradeRev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "detailCell"
    
class PhotoDetailCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var labelLikes: UILabel!
        @IBOutlet weak var labelUsername: UILabel!
        @IBOutlet weak var labelPublishedOn: UILabel!
        @IBOutlet weak var labelDimension: UILabel!
        
        @IBOutlet weak var photoInformationViewTop:UIView!
        @IBOutlet weak var photoInformationViewBottom:UIView!
        
        weak var collectionViewScrollToIndexDelegate:CollectionViewScroll?
        var selectedIndexPath: IndexPath?
        
        lazy var viewModel: PhotoDetailViewModel = {
            return PhotoDetailViewModel()
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            initLayout()
            initViewModel()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super .viewWillAppear(animated)
            
            if let indexPath = selectedIndexPath {
                collectionView.layoutIfNeeded()
                collectionView.collectionViewLayout.invalidateLayout()
                
                collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
                updatePhotoInfo(at: indexPath.row)
                
                
            }
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            let newOffset = getOffsetForVisibleCell(size: size)
            coordinator.animate(alongsideTransition: { [weak self] context in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.collectionView.setContentOffset(newOffset, animated: false)
                strongSelf.collectionView.collectionViewLayout.invalidateLayout()
            })
            
        }
    }
    
    //MARK: Initial Helper
    extension PhotoDetailCollectionViewController {
        fileprivate func initLayout() {
            // Register cell classes
            
            
            // Do any additional setup after loading the view.
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collectionView.collectionViewLayout = layout
            collectionView.delegate = self
            collectionView.isPagingEnabled = true
            
        }
        
        fileprivate func initViewModel() {
            viewModel.reloadViewClosure = { [weak self] (success, error) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {
                    strongSelf.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    extension PhotoDetailCollectionViewController {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.numberOfCells
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoGridViewCell
            
            // Configure the cell
            if let photoCellViewModel = viewModel.getCellViewModel(at: indexPath.row) {
                cell.imageUrl = photoCellViewModel.photoUrl
            }
            viewModel.fetchPhotosIfNeeded(for: indexPath.row)
            return cell
        }
        
    }
    
    // MARK: UICollectionViewDelegate
    extension PhotoDetailCollectionViewController {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return collectionView.frame.size
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let indexPathList = collectionView.indexPathsForVisibleItems
            let indexPath = indexPathList.count > 0 ? indexPathList[0] : nil
            if let indexPath = indexPath {
                updatePhotoInfo(at: indexPath.row)
            }
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            animatePhotoInformationViewVisibility()
        }
    }
    
    // MARK: Button action handler
    extension PhotoDetailCollectionViewController {
        @IBAction func btnCloseHandler(_ sender: UIButton) {
            let indexPathList = collectionView.indexPathsForVisibleItems
            let indexPath = indexPathList.count > 0 ? indexPathList[0] : nil
            if let collectionViewScrollToIndexDelegate = collectionViewScrollToIndexDelegate {
                collectionViewScrollToIndexDelegate.collectionViewWillMove(at: indexPath)
            }
            dismiss(animated: true, completion: {
                
            })
        }
    }
    
    // MARK: Helper Update Photo Information
    extension PhotoDetailCollectionViewController {
        
        fileprivate func animatePhotoInformationViewVisibility() {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                // Do animation
                guard let strongSelf = self else {
                    return
                }
                strongSelf.photoInformationViewTop.isHidden = strongSelf.photoInformationViewTop.isHidden == true ? false : true
            })
            
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                // Do animation
                guard let strongSelf = self else {
                    return
                }
                strongSelf.photoInformationViewBottom.isHidden = strongSelf.photoInformationViewBottom.isHidden == true ? false : true
            })
        }
        
        fileprivate func getOffsetForVisibleCell(size: CGSize) -> CGPoint{
            let offset = collectionView.contentOffset;
            let width = collectionView.bounds.size.width;
            
            let index =  round(offset.x / width);
            let newOffset = CGPoint(x: index * size.width, y: offset.y)
            return newOffset
        }
        
        fileprivate func updatePhotoInfo(at index: Int) {
            if let cellData = viewModel.getCellViewModel(at: index) {
                labelUsername.text = cellData.publisherName
                labelLikes.text = cellData.likes
                labelDimension.text = cellData.dimension
                labelPublishedOn.text = cellData.publishedOn
            }
            
        }
}
