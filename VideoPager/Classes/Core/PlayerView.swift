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
    func playerView(didPlayToEndTime view: PlayerView)
    func playerView(didStartPlayback view: PlayerView)
    func playerView(didChangeSpeedRate rate: Float)
    func playerView(didChangeSkipEnabledState front: Bool, back: Bool)
    func playerView(didChangeCurrentTime currentTime: NSTimeInterval, duration: NSTimeInterval)
    func playerView(playButtonIconShouldBeChangeToPauseIcon isPauseButton: Bool)
    func playerView(controlViewsShouldBeDisable disable: Bool)
    func playerView(activityIndicatorShouldBeVisible visible: Bool)
}

/// videoView + control UI
class PlayerView: UIView {

    let bottomLayerView = UIView()
    private let videoView = VideoView()
    let middleLayerView = UIView()
    
    weak var delegate: PlayerViewDelegate!
    var enableFadeAnimation = true
    private var disposeBag = DisposeBag()
    
    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        videoView.delegate = self
        addSubview(bottomLayerView)
        addSubview(videoView)
        addSubview(middleLayerView)
        videoView.rx_observe(Bool.self, "shouldShowIndicator").subscribeOn(MainScheduler.instance).subscribeNext { [weak self] value in
            guard let shouldShowIndicator = value else { return }
            self?.delegate?.playerView(activityIndicatorShouldBeVisible: shouldShowIndicator)
        }
        .addDisposableTo(self.disposeBag)
        togglePlayer(visible: false, animated: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        videoView.frame = bounds
        middleLayerView.frame = bounds
        bottomLayerView.frame = bounds
    }
    
    // MARK: - control methods
    
    func setUrlAndPlay(url: NSURL) {
        delegate.playerView(activityIndicatorShouldBeVisible: true)
        videoView.play(url)
    }
    
    func pause(bySystem bySystem: Bool = false) {
        videoView.pause(bySystem: bySystem)
        delegate.playerView(playButtonIconShouldBeChangeToPauseIcon: false)
    }
    
    func stop() {
        videoView.stop()
        delegate.playerView(playButtonIconShouldBeChangeToPauseIcon: false)
    }
    
    func playFromCurrentTime() {
        delegate.playerView(playButtonIconShouldBeChangeToPauseIcon: true)
        videoView.playFromCurrentTime()
    }
    
    func restorePlayer() {
        delegate.playerView(activityIndicatorShouldBeVisible: false)
        let result = videoView.restorePlayer()
        if result == .ReCreatePlayerAndPlayed {
            togglePlayer(visible: false, animated: false)
        }
        delegate.playerView(playButtonIconShouldBeChangeToPauseIcon: result != .NotNeededToPlay)
    }
    
    func resetControlView() {
        delegate.playerView(playButtonIconShouldBeChangeToPauseIcon: true)
        delegate.playerView(activityIndicatorShouldBeVisible: false)
        togglePlayer(visible: false, animated: false)
    }
}

extension PlayerView: VideoViewDelegate {

    func videoViewDidPlayToEndTime() {
        delegate.playerView(didPlayToEndTime: self)
    }
    
    func videoViewPlaybackDidEnd() {
    }
    
    func videoViewPlaybackDidFailed() {
        delegate.playerView(didFailedToPlay: self)
    }
    
    func videoView(currentTimeDidChange time: NSTimeInterval) {
        delegate.playerView(didChangeCurrentTime: videoView.currentTime, duration: videoView.duration)
    }
    
    func videoView(shouldToggleIndicatorShow show: Bool) {
        delegate.playerView(activityIndicatorShouldBeVisible: show)
    }
    
    func videoView(shouldTogglePlayerButtonIconIsPause isPauseIcon: Bool) {
        delegate.playerView(playButtonIconShouldBeChangeToPauseIcon: isPauseIcon)
    }
    
    func videoView(bufferingProgressDidChange bufferProgress: Float) {
    }
    
    func videoViewDidStartPlayback() {
        delegate.playerView(playButtonIconShouldBeChangeToPauseIcon: true)
        delegate.playerView(didStartPlayback: self)
        togglePlayer(visible: true, animated: true)
    }
    
    func videoViewDidChangeSpeedRate(rate: Float) {
        delegate.playerView(didChangeSpeedRate: rate)
    }
    
    func videoViewDidChangeSkipEnabledState(front: Bool, back: Bool) {
        delegate.playerView(didChangeSkipEnabledState: front, back: back)
    }
}

// MARK: - private uitility methods

extension PlayerView {
    
    private func togglePlayer(visible visible: Bool, animated: Bool) {
        let animated = animated && enableFadeAnimation
        videoView.toggleView(visible, animated: animated)
        delegate?.playerView(controlViewsShouldBeDisable: !visible)
    }
}

private extension UIView {

    func toggleView(visible: Bool, animated: Bool, duration: NSTimeInterval = 0.4) {
        if !animated {
            self.alpha = visible ? 1 : 0
        } else {
            UIView.beginAnimations("showPlayerView", context: nil)
            UIView.setAnimationDuration(duration)
            self.alpha = visible ? 1 : 0
            UIView.commitAnimations()
        }
    }
}

// MARK: - bridging properties and methods

extension PlayerView {
    
    func skipFront() {
        videoView.skipFront()
    }

    func skipBack() {
        videoView.skipBack()
    }
 
    func seek(value: Double) {
        videoView.seek(value)
    }
    
    func seekToTime(time: NSTimeInterval) {
        videoView.seekToTime(time)
    }
    
    var currentTime: NSTimeInterval { return videoView.currentTime }
    
    var duration: NSTimeInterval { return videoView.duration }

    var videoGravity: String? {
        get {
            return videoView.videoGravity
        }
        set {
            videoView.videoGravity = newValue
        }
    }

    var speedRate: Float? {
        get {
            return videoView.speedRate
        }
        set {
            videoView.speedRate = newValue
        }
    }
    
    var pausedBySystem: Bool { return videoView.pausedBySystem }
    
    var pausedByUser: Bool { return videoView.pausedByUser }
}