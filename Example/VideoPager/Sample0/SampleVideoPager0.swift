//
//  SampleVideoPager0.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 2016/09/23.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import VideoPager

class SampleVideoPager0: VideoPagerViewController {
    
    required init?(coder aDecoder: NSCoder) {
        let cellNib = UINib(nibName: "SampleCell0", bundle: nil)
        super.init(coder: aDecoder, videoPagerCellNib: cellNib)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUrls(onlineSampleUrls)
    }
    
    override func didSelectItemAtIndex(index: Int) {
        super.didSelectItemAtIndex(index)
        activeCell?.playOrPause()
    }
    
    @IBAction func didTapCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}