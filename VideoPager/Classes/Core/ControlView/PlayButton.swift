//
//  PlayButton.swift
//  PlayerPagingCollectionView
//
//  Created by Takuya Okamoto on 2016/08/14.
//  Copyright © 2016 Takuya Okamoto. All rights reserved.
//

import UIKit
import AVFoundation

class PlayButton: UIButton {
    
    var playIcon: UIImage {
        didSet {
            self.toggleIcon(pauseIcon: self.isPauseIcon)
        }
    }
    
    var pauseIcon: UIImage {
        didSet {
            self.toggleIcon(pauseIcon: self.isPauseIcon)
        }
    }

    private let padding: CGFloat = 8

    private(set) var isPauseIcon: Bool = true {
        didSet {
            self.setImage(isPauseIcon ? pauseIcon : playIcon, forState: .Normal)
        }
    }
    
    init(playIcon: UIImage, pauseIcon: UIImage, backgroundColor: UIColor) {
        self.playIcon = playIcon
        self.pauseIcon = pauseIcon
        super.init(frame: CGRect.zero)
        self.contentMode = .Center
        self.backgroundColor = backgroundColor
        self.toggleIcon(pauseIcon: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toggleIcon(pauseIcon isPauseIcon: Bool) {
        self.isPauseIcon = isPauseIcon
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}