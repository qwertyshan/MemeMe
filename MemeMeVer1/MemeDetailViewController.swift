//
//  MemeDetailViewController.swift
//  MemeMeVer2
//
//  Created by Shantanu Rao on 1/2/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var editMemeButton: UIBarButtonItem!
    
    var meme: Meme!
    var memeIndex: Int? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memeImage!.image = self.meme.memedImage
        
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "editMemeSegue") {
            
            let controller = segue.destinationViewController as! MemeEditViewController
            
            controller.memeIndex = memeIndex
        }
    }
    
}