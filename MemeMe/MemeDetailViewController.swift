//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by admin on 11/22/15.
//  Copyright © 2015 admin. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var selectedMeme: Meme!
    
    @IBOutlet weak var detailMemeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectMemeImage = selectedMeme.memedImage {
            detailMemeImage.image = selectMemeImage
        }
    }
}
