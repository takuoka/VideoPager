//
//  ViewController.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 08/17/2016.
//  Copyright (c) 2016 Takuya Okamoto. All rights reserved.
//

import UIKit
import VideoPager

class ViewController: UIViewController {

    @IBAction func openVideoPagerViewController(sender: AnyObject) {
        let videoPager = VideoPagerViewController()
        videoPager.updateUrls(onlineSampleUrls)
        presentViewController(videoPager, animated: true, completion: nil)
    }
}