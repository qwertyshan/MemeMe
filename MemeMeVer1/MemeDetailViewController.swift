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
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memeImage!.image = self.meme.memedImage
        
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
}