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
        
        // Set the name and image
        if let textLabel = cell.textLabel {
            textLabel.text = meme.textTop + "... " + meme.textBottom
        }
      /*  if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.textBottom
        } */
        if let imageView = cell.imageView {
            imageView.image = meme.memedImage
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.item]
        navigationController!.pushViewController(detailController, animated: true)
        
    }

}