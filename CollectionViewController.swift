//
//  CollectionViewController.swift
//  MemeMeVer2
//
//  Created by Shantanu Rao on 1/2/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
    /*    switch UIDevice.currentDevice().orientation {
        case .Unknown, .Portrait, .PortraitUpsideDown, .FaceDown, .FaceUp:
            let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        default:
            let dimension = (self.view.frame.size.height - (2 * space)) / 5.0

        }*/
        
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    // MARK: UICollectionViewFlowLayoutDelegate
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let memedImage = self.memes[indexPath.row].memedImage //Select meme on current row
            return memedImage.size
    }
    
    
    // MARK: Collection View Data Source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row] //Select meme on current row
        
        // Set the name and image
        if let textLabel = cell.topLabel {
            textLabel.text = meme.textTop
        }
        if let detailTextLabel = cell.bottomLabel {
            detailTextLabel.text = meme.textBottom
        }
        if let imageView = cell.imageView {
            imageView.image = meme.memedImage
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

}