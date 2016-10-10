//
//  SampleCell0.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 2016/09/23.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import VideoPager

/// simple cell

class SampleCell0: VideoPagerCell, VideoPagerCustomUI {
    
    // MARK: - VideoPagerCustomUI
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func initialize() {
        super.initialize()
        thumbnailView.contentMode = .ScaleAspectFill
    }
}