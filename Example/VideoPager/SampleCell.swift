//
//  SampleCell.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 2016/08/19.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import VideoPager

class SampleCell: VideoPagerCell {
    
    // sample views
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func initialize() {
        super.initialize()
        // do someting
    }

    override func didEndPlayback() {
        // do someting
    }
    
    override func didFailedToPlay() {
        // do someting
    }
    
    @IBAction func didTapButton(sender: AnyObject) {
        self.button.frame.size.width += 10
    }
}
