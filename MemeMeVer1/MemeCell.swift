//
//  MemeCell.swift
//  MemeMeVer2
//
//  Created by Shantanu Rao on 2/2/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import Foundation
import UIKit

class MemeCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellText: UILabel!
    
    func loadItem(image image: UIImage?, text: String?) {
        if let image = image {
            cellImage.image = image
        }
        if let text = text {
            cellText.text = text
        }
    }
}