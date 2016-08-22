//
//  ControlView.swift
//  PlayerPagingCollectionView
//
//  Created by Takuya Okamoto on 2016/08/14.
//  Copyright © 2016 Takuya Okamoto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import AVFoundation

protocol ControlViewDelegate: class {
    func controlViewDidTapPause()
    func controlViewDidTapPlay()
    func controlView(didSlideSeekBar value: Double)
    func controlView(didStartSlide value: Double)
    func controlView(didEndSlide value: Double)
}

class ControlView: UIView {
    
    weak var delegate: ControlViewDelegate!
    
    private let playButton: PlayButton
    private let seekBar: SeekBar
    private var disposeBag = DisposeBag()
    
    init(playIcon: UIImage, pauseIcon: UIImage, playButtonBackgroundColor: UIColor, timerFont: UIFont, timerTextColor: UIColor, minimumTrackColor: UIColor, maximumTrackColor: UIColor, bufferProgressColor: UIColor) {
        self.playButton = PlayButton(playIcon: playIcon, pauseIcon: pauseIcon, backgroundColor: playButtonBackgroundColor)
        self.seekBar = SeekBar(timerFont: timerFont, timerTextColor: timerTextColor, minimumTrackColor: minimumTrackColor, maximumTrackColor: maximumTrackColor, bufferProgressColor: bufferProgressColor)
        super.init(frame: CGRect.zero)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.seekBar.delegate = self
        self.setupViews()
        self.playButton.addTarget(self, action: #selector(self.dynamicType.didTapPlayButton), forControlEvents: .TouchUpInside)
    }
    
    func setSeekValue(value: Double, animated: Bool) {
        self.seekBar.setSeekValue(value, animated: animated)
    }

    func setPlayingTimeLabelText(sec sec: Double, duration: Double) {
        self.seekBar.setPlayingTimeLabelText(sec: sec, duration: duration)
    }
    
    func togglePlayButtonIcon(pauseIcon pauseIcon: Bool) {
        self.playButton.toggleIcon(pauseIcon: pauseIcon)
    }
}

// MARK: - Events
extension ControlView {
 
    func didTapPlayButton() {
        self.playButton.isPauseIcon
            ? delegate.controlViewDidTapPause()
            : delegate.controlViewDidTapPlay()
    }
}

extension ControlView: SeekBarDelegate {

    func seekBar(didSlide value: Double) {
        delegate.controlView(didSlideSeekBar: value)
    }
    
    func seekBar(didTouchDown value: Double) {
        delegate.controlView(didStartSlide: value)
    }

    func seekBar(didTouchUp value: Double) {
        delegate.controlView(didEndSlide: value)
    }
}

// MARK: - Design
extension ControlView {
    
    private func setupViews() {
        self.addSubview(playButton)
        self.addSubview(seekBar)
        self.playButton.frame.size = CGSize(width: 36, height: 36)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let seekBarMarginLeft: CGFloat = 10
        let seekBarMarginRight: CGFloat = 19
        
        self.playButton.frame.origin.x = seekBarMarginLeft
        
        self.seekBar.frame.size.height = 62
        let seekBarBottomMargin: CGFloat = 8 - (self.seekBar.frame.size.height - 32) / 2
        self.seekBar.frame.size.width = self.frame.width - (self.playButton.frame.size.width + seekBarMarginLeft + seekBarMarginRight)
        self.seekBar.frame.origin.x = self.playButton.frame.origin.x + self.playButton.frame.size.width
        self.seekBar.frame.origin.y = self.frame.height - self.seekBar.frame.height - seekBarBottomMargin
        
        self.playButton.center.y = self.seekBar.center.y
    }
}

// MARK: - bridging property
extension ControlView {
    
    var playIcon: UIImage {
        set {
            self.playButton.playIcon = newValue
        }
        get {
            return self.playButton.playIcon
        }
    }
    
    var pauseIcon: UIImage {
        set {
            self.playButton.pauseIcon = newValue
        }
        get {
            return self.playButton.pauseIcon
        }
    }
}