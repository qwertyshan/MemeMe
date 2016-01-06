//
//  CollectionViewController.swift
//  MemeMeVer2
//
//  Created by Shantanu Rao on 1/2/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!    
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDimensions()
    }

    func setDimensions() {
        let space: CGFloat = 3.0
        let dimension: CGFloat
        
        // Check for device orientation and set dimensions
        if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
            dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        }
        else {
            dimension = (self.view.frame.size.width - (4 * space)) / 5.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }

    // MARK: UICollectionViewFlowLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
                        
        return CGSizeMake(100,100)
    }
    
    
    // MARK: Collection View Data Source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row] //Select meme on current row
        
        if let imageView = cell.imageView {
            imageView.image = meme.memedImage
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        detailController.memeIndex = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

}