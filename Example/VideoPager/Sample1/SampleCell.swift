//
//  SampleCell.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 2016/08/19.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import VideoPager

/// player sample 1

class SampleCell: VideoPagerCell, VideoPagerCustomUI {
    
    // MARK: - VideoPagerCustomUI
    @IBOutlet weak var playButton: UIButton!
    var playIcon: UIImage = UIImage(named: "Play")!
    var pauseIcon: UIImage = UIImage(named: "Pause")!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var frontSkipButton: UIButton!
    @IBOutlet weak var backSkipButton: UIButton!
    @IBOutlet weak var playSpeedButton: UIButton!
    var speedRateList: [Float] = [1.0, 1.2, 1.5, 2.0, 0.5]
    var topShadowHeight: CGFloat = 100
    var bottomShadowHeight: CGFloat = 116
    @IBOutlet weak var seekSlider: UISlider!
    
    // MARK: - Views
    @IBOutlet weak var urlLabel: UILabel!
}