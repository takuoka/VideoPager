//
//  SampleVideoPager.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 2016/08/23.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import VideoPager

/// player sample 1

class SampleVideoPager: VideoPagerViewController {
    
    required init?(coder aDecoder: NSCoder) {
        let cellNib = UINib(nibName: "SampleCell", bundle: nil)
        super.init(coder: aDecoder, videoPagerCellNib: cellNib)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUrls(onlineSampleUrls)
    }
    
    override func configureCell(cell: VideoPagerCell, index: Int) {
        super.configureCell(cell, index: index)
        if let cell = cell as? SampleCell {
            cell.urlLabel.text = onlineSampleUrls[index].path
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func didTapCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}