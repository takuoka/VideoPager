//
//  SampleVideoPager2.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 2016/09/23.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import VideoPager

/// player sample 2

class SampleVideoPager2: VideoPagerViewController {
    
    required init?(coder aDecoder: NSCoder) {
        let cellNib = UINib(nibName: "SampleCell2", bundle: nil)
        super.init(coder: aDecoder, videoPagerCellNib: cellNib)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUrls(localSampleVideoUrls)
    }
    
    override func configureCell(cell: VideoPagerCell, index: Int) {
        super.configureCell(cell, index: index)
        cell.thumbnailView.image = UIImage(named: localSampleThumbnailNames[index])
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func didTapCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}