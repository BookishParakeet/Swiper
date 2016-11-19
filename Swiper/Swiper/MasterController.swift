//
//  ViewController.swift
//  Swiper
//
//  Created by 李秦琦 on 11/13/16.
//  Copyright © 2016 BookishParakeet. All rights reserved.
//

import UIKit
import Social
import MessageUI
import AVFoundation

class MasterController: UIViewController {
    @IBOutlet var navigationBar: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set title image
        self.navigationItem.titleView = UIImageView(image:#imageLiteral(resourceName: "BarTitle"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

