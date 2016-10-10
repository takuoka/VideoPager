//
//  SampleCell2.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 2016/09/23.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import VideoPager

/// player sample 2

class SampleCell2: VideoPagerCell, VideoPagerCustomUI {

    // MARK: - VideoPagerCustomUI
    var playIcon: UIImage = UIImage(named: "Play_small")!
    var pauseIcon: UIImage = UIImage(named: "Pause_small")!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var seekSlider: UISlider!
    var bottomShadowHeight: CGFloat = 44
    var topShadowHeight: CGFloat = 52
    var shadowOpacity: CGFloat = 0.3
    var fadeEnabledViews: [UIView] {
        return [
            playButton,
            currentTimeLabel,
            remainTimeLabel,
            seekSlider,
            bottomShadowView
        ]
    }
    
    override func initialize() {
        super.initialize()
        thumbnailView.contentMode = .ScaleAspectFill
    }

    override func willLayoutSubViewsFirst() {
        seekSlider.setThumbImage(makeCircleImage(size: 12), forState: .Normal)
    }
    
    override func preferVideoFillMode() -> VideoPagerFillMode {
        return VideoPagerFillMode.AspectFill
    }
}