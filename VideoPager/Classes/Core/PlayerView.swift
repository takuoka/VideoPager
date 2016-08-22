//
//  PlayerView.swift
//  PlayerPagingCollectionView
//
//  Created by Takuya Okamoto on 2016/08/13.
//  Copyright © 2016 Takuya Okamoto. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import RxSwift

protocol PlayerViewDelegate: class {
    func playerView(didFailedToPlay view: PlayerView)
    func playerView(didEndPlayback view: PlayerView)
}

// videoView + controlView = PlayerView
class PlayerView: UIView {

    private let videoView = VideoView()
    private let controlView: ControlView
    
    weak var delegate: PlayerViewDelegate?
    private let activityIndicator: UIActivityIndicatorView
    private var isDraggingSeekBar = false
    private var disposeBag = DisposeBag()

    init(
        playIcon: UIImage = imageFromBundle(name: "play")!,
        pauseIcon: UIImage = imageFromBundle(name: "pause")!,
        playButtonBackgroundColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.3),
        timerFont: UIFont = UIFont.systemFontOfSize(12),
        timerTextColor: UIColor = UIColor.whiteColor(),
        minimumTrackColor: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.95),
        maximumTrackColor: UIColor = UIColor(white: 0.2, alpha: 0.95),
        bufferProgressColor: UIColor = UIColor.redColor().colorWithAlphaComponent(0.8),
        activityIndicatorStyle: UIActivityIndicatorViewStyle = .WhiteLarge,
        activityIndicatorColor: UIColor = UIColor.redColor()
    ) {
        self.controlView = ControlView(playIcon: playIcon, pauseIcon: pauseIcon, playButtonBackgroundColor: playButtonBackgroundColor, timerFont: timerFont, timerTextColor: timerTextColor, minimumTrackColor: minimumTrackColor, maximumTrackColor: maximumTrackColor, bufferProgressColor: bufferProgressColor)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
        self.activityIndicator.color = activityIndicatorColor
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        videoView.delegate = self
        controlView.delegate = self
        self.addSubview(videoView)
        self.addSubview(controlView)
        self.addSubview(self.activityIndicator)
        videoView.rx_observe(Bool.self, "shouldShowIndicator").subscribeNext { [weak self] value in
            guard let shouldShowIndicator = value, wself = self else { return }
            shouldShowIndicator
                ? wself.activityIndicator.startAnimating()
                : wself.activityIndicator.stopAnimating()
        }
        .addDisposableTo(self.disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        videoView.frame = self.bounds
        controlView.frame = self.bounds
        activityIndicator.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    }
    
    func setUrlAndPlay(url: NSURL) {
        videoView.play(url)
    }
    
    func pause() {
        videoView.pause()
    }
    
    func playFromCurrentTime() {
        videoView.playFromCurrentTime()
    }
}

extension PlayerView: VideoViewDelegate {
    
    func videoView(playbackDidEnd player: Player) {
        delegate?.playerView(didEndPlayback: self)
    }
    
    func videoView(playbackDidFailed player: Player) {
        delegate?.playerView(didFailedToPlay: self)
    }
    
    func videoView(currentTimeDidChange time: NSTimeInterval) {
        if !isDraggingSeekBar {
            controlView.setPlayingTimeLabelText(sec: videoView.currentTime, duration: videoView.duration)
            controlView.setSeekValue(videoView.currentTime / videoView.duration, animated: false)
        }
    }
    
    func videoView(shouldToggleIndicatorShow show: Bool) {
        show
            ? activityIndicator.startAnimating()
            : activityIndicator.stopAnimating()
    }
    
    func videoView(shouldTogglePlayerButtonIconIsPause isPauseIcon: Bool) {
        controlView.togglePlayButtonIcon(pauseIcon: isPauseIcon)
    }
    
    func videoView(bufferingProgressDidChange bufferProgress: Float) {
    }
}

extension PlayerView: ControlViewDelegate {

    func controlViewDidTapPlay() {
        videoView.playFromCurrentTime()
        controlView.togglePlayButtonIcon(pauseIcon: true)
    }

    func controlViewDidTapPause() {
        videoView.pause()
        controlView.togglePlayButtonIcon(pauseIcon: false)
    }
    
    func controlView(didSlideSeekBar value: Double) {
        let slidingSec = value * videoView.duration
        controlView.setPlayingTimeLabelText(sec: slidingSec, duration: videoView.duration)
    }
    
    func controlView(didStartSlide value: Double) {
        isDraggingSeekBar = true
        videoView.pause()
    }
    
    func controlView(didEndSlide value: Double) {
        isDraggingSeekBar = false
        controlView.setPlayingTimeLabelText(sec: videoView.currentTime, duration: videoView.duration)
        videoView.seek(value)
        videoView.playFromCurrentTime()
    }
}

private func imageFromBundle(name name: String)->UIImage? {
    return UIImage(named: name, inBundle: NSBundle(forClass: PlayerView.self), compatibleWithTraitCollection: nil)
}

// MARK: - bridging property
extension PlayerView {
    
    var playIcon: UIImage {
        set {
            controlView.playIcon = newValue
        }
        get {
            return controlView.playIcon
        }
    }
    
    var pauseIcon: UIImage {
        set {
            controlView.pauseIcon = newValue
        }
        get {
            return controlView.pauseIcon
        }
    }
}