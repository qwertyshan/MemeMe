//
//  TableViewController.swift
//  MemeMeVer2
//
//  Created by Shantanu Rao on 1/1/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableViewOutlet.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MemeCell")
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")! as UITableViewCell
        let meme = memes[indexPath.item] //Select meme on current row
        
        // Set substrings
        let strFirst = meme.textTop.characters.prefix(10)
        let strSecond = meme.textBottom.characters.prefix(10)
        
        // Set the name and image
        if let textLabel = cell.textLabel {
            textLabel.text =  String(strFirst) + "... " + String(strSecond)
        }
        if let imageView = cell.imageView {
            imageView.image = meme.memedImage
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.item]
        detailController.memeIndex = indexPath.row
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    // Delete row
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the model
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
                
                // remove the deleted item from the `UITableView`
                tableViewOutlet.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }

}