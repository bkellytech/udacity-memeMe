//
//  MemesSentViewController.swift
//  MemeMe
//
//  Created by admin on 11/16/15.
//  Copyright © 2015 admin. All rights reserved.
//

import UIKit

class MemesSentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as UITableViewCell!
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = ""
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "\(meme.topTextField)...\(meme.bottomTextField)"
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let meme = memes[indexPath.row]
        let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = meme
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
