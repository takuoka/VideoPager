//
//  VideoView.swift
//  PlayerPagingCollectionView
//
//  Created by Takuya Okamoto on 2016/08/14.
//  Copyright © 2016 Takuya Okamoto. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import RxSwift
import RxCocoa

protocol VideoViewDelegate: class {
    func videoView(currentTimeDidChange time: NSTimeInterval)
    func videoViewPlaybackDidEnd()
    func videoViewPlaybackDidFailed()
    func videoView(bufferingProgressDidChange bufferProgress: Float)// TODO: call
    func videoView(shouldTogglePlayerButtonIconIsPause isPauseIcon: Bool)
    func videoViewDidStartPlayback()
    func videoViewDidPlayToEndTime()
    func videoViewDidChangeSpeedRate(rate: Float)
    func videoViewDidChangeSkipEnabledState(front: Bool, back: Bool)
}

enum RestorePlayerResult {
    case JustPlayed
    case ReCreatePlayerAndPlayed
    case Failed
    case NotNeededToPlay
}

/**
 view just play the video
*/
class VideoView: UIView {
    
    static var sharedPlayer = Player()
    class func disposeSharedPlayer() {
        (sharedPlayer.view.superview as? VideoView)?.player = nil
        sharedPlayer.view.removeFromSuperview()
        sharedPlayer.delegate = nil
        sharedPlayer.stop()
    }
    var singletonePlayer: Player {
        get {
            return self.dynamicType.sharedPlayer
        }
        set {
            self.dynamicType.sharedPlayer = newValue
        }
    }
    private dynamic var enableFrontSkip = false
    private dynamic var enableBackSkip = false
    private var skipSec: NSTimeInterval = 10
    
    weak var delegate: VideoViewDelegate!
    dynamic var shouldShowIndicator = false// please observe
    var currentTime: NSTimeInterval {
        return self.player?.currentTime.isNaN == true ? 0 : self.player?.currentTime ?? 0
    }
    var duration: NSTimeInterval {
        return self.player?.maximumDuration ?? 0
    }
    var videoGravity: String? {
        get {
            return player?.fillMode
        }
        set {
            self.player?.fillMode = newValue
        }
    }
    var speedRate: Float? {
        get {
            return player?.speedRate
        }
        set {
            guard let speedRate = newValue else { return }
            self.player?.speedRate = speedRate
            delegate.videoViewDidChangeSpeedRate(speedRate)
        }
    }
    
    private weak var player: Player?
    private var currentURL: NSURL?
    private var seekQueue: NSTimeInterval?
    private var lastPausedAt: NSTimeInterval?
    var pausedByUser = false
    var pausedBySystem = false
    private var isStartedPlayback = false {
        didSet {
            if !oldValue && isStartedPlayback {
                shouldShowIndicator = false
                delegate.videoViewDidStartPlayback()
            }
        }
    }
    private var disposeBag = DisposeBag()

    // MARK: - initialize
    
    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        setupObservingSkipEnabledState()
        setupObservingCallingAndHeadPhone()
    }

    // MARK: - LifeCycle
    
    func play(url: NSURL) {
        shouldShowIndicator = true
        isStartedPlayback = false
        pausedByUser = false
        pausedBySystem = false
        enableFrontSkip = false
        enableBackSkip = false
        lastPausedAt = nil
        // reset singletone Player
        singletonePlayer.stop()
        if let previousVideoView = singletonePlayer.view.superview as? VideoView {
            previousVideoView.player = nil
            singletonePlayer.view.removeFromSuperview()
            if let preUrl = singletonePlayer.currentURL
                where url.pathExtension != preUrl.pathExtension
            {
                singletonePlayer = Player()
            }
        }
        // get singletone Player
        player = singletonePlayer
        player!.delegate = self
        // add to this
        player!.view.frame = self.bounds
        self.addSubview(player!.view)
        // play
        setUrl(url) { [weak self] in
            guard let wself = self else { return }
            if let seekQueue = wself.seekQueue {
                wself.seekToTime(seekQueue)
                wself.seekQueue = nil
            }
        }
    }
    
    /// call when comeback from another view, because then the player property could be nil.
    func restorePlayer() -> RestorePlayerResult {
        if let
            player = self.player,
            playerSuperview = player.view.superview as? VideoView
        where
            playerSuperview == self
         && player.currentURL == self.currentURL
        {
            guard !pausedByUser else { return .NotNeededToPlay }
            player.playFromCurrentTime()
            return .JustPlayed
        }
        else if let url = currentURL {
            seekQueue = lastPausedAt
            if pausedByUser {
                play(url)
                pausedByUser = true
                return .NotNeededToPlay
            }
            play(url)
            return .ReCreatePlayerAndPlayed
        }
        return .Failed
    }

    // MARK: - control video
    
    func playFromCurrentTime() {
        pausedByUser = false
        pausedBySystem = false
        player?.playFromCurrentTime()
    }

    func pause(bySystem bySystem: Bool = false) {
        if bySystem {
            pausedBySystem = true
        } else {
            pausedByUser = true
        }
        player?.pause()
        lastPausedAt = player?.currentTime
    }
    
    func stop() {
        player?.stop()
    }
    
    func seek(value: Double) {
        guard !duration.isNaN else { return }
        seekToTime(duration * value)
    }

    func skipFront() {
        guard enableFrontSkip else { return }
        seekToTime(currentTime + skipSec)
    }

    func skipBack() {
        guard enableBackSkip else { return }
        seekToTime(max(0, currentTime - skipSec))
    }

    func seekToTime(time: NSTimeInterval) {
        player?.seekToTimePrecision(time)
    }
    
    private func setUrl(url: NSURL, complition: (()->Void)? = nil) {
        player?.setUrl(url, complition: complition)
        currentURL = url
    }

    // MARK: - Life cycle of UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        player?.view.frame = self.bounds
    }
}


extension VideoView: PlayerDelegate {
    
    func playerItemDidPlayToEndTimeNotification(player: Player) {
        delegate.videoViewDidPlayToEndTime()
    }
    
    func playerReady(player: Player) {
    }
    
    func playerPlaybackStateDidChange(player: Player) {
        guard let state = player.playbackState else { return }
        switch state {
        case .Paused:
            break
        case .Playing:
            if let bufferingState = player.bufferingState where bufferingState == .Ready {
                if !isStartedPlayback {
                    isStartedPlayback = true
                } else {
                    shouldShowIndicator = false
                }
            }
        case .Stopped:
            break
        case .Failed:
            shouldShowIndicator = false
            self.dynamicType.disposeSharedPlayer()
            delegate.videoViewPlaybackDidFailed()
        }
    }
    
    func playerBufferingStateDidChange(player: Player) {
        guard let state = player.bufferingState else { return }
        switch state {
        case .Unknown:
            shouldShowIndicator = true
        case .Delayed:
            shouldShowIndicator = true
        case .Ready:
            if !pausedByUser && !pausedBySystem {
                player.playFromCurrentTime()
            }
            if !isStartedPlayback {
                isStartedPlayback = true
            } else {
                shouldShowIndicator = false
            }
        }
    }
    
    func playerCurrentTimeDidChange(player: Player) {
        let currentTime = player.currentTime
        let duration = player.maximumDuration
        if  !currentTime.isNaN && !duration.isNaN {
            delegate.videoView(currentTimeDidChange: currentTime)
            let remainTime = duration - currentTime
            enableFrontSkip = remainTime > skipSec
            enableBackSkip = currentTime > 0
        }
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
    }
    
    func playerPlaybackDidEnd(player: Player) {
        delegate.videoViewPlaybackDidEnd()
    }
    
    func playerWillComeThroughLoop(player: Player) {
    }
}

// MARK: observe calling and head-phone event

extension VideoView {
    
    func setupObservingSkipEnabledState() {

        self.rx_observeWeakly(Bool.self, "enableFrontSkip").subscribeNext { [weak self] value in
            guard let enableFrontSkip = value, wself = self else { return }
            wself.delegate?.videoViewDidChangeSkipEnabledState(enableFrontSkip, back: wself.enableBackSkip)
        }
        .addDisposableTo(self.disposeBag)

        self.rx_observeWeakly(Bool.self, "enableBackSkip").subscribeNext { [weak self] value in
            guard let enableBackSkip = value, wself = self else { return }
            wself.delegate?.videoViewDidChangeSkipEnabledState(wself.enableFrontSkip, back: enableBackSkip)
        }
        .addDisposableTo(self.disposeBag)
    }
    
    func setupObservingCallingAndHeadPhone() {
        
        // When interrupted by callingvideoViewDidStartPlayback
        NSNotificationCenter.defaultCenter().rx_notification(AVAudioSessionInterruptionNotification)
            .subscribeOn(MainScheduler.instance)
            .subscribeNext { [weak self] (notification: NSNotification) in
                guard let wself = self else { return }
                let keyNumber = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as! NSNumber
                let type = AVAudioSessionInterruptionType(rawValue: keyNumber.unsignedLongValue)
                if let type = type {
                    if type == .Began {
                        wself.pause()
                        wself.delegate.videoView(shouldTogglePlayerButtonIconIsPause: false)
                    }
                    if type == .Ended {
                        wself.playFromCurrentTime()
                        wself.delegate.videoView(shouldTogglePlayerButtonIconIsPause: true)
                    }
                }
            }
            .addDisposableTo(self.disposeBag)
        
        // When the head-phone is pluged out
        NSNotificationCenter.defaultCenter().rx_notification(AVAudioSessionRouteChangeNotification)
            .subscribeOn(MainScheduler.instance)
            .subscribeNext { [weak self] (notification: NSNotification) in
                guard let wself = self else { return }
                let keyNumber = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as! NSNumber
                let type = AVAudioSessionRouteChangeReason(rawValue: keyNumber.unsignedLongValue)
                if let type = type {
                    if case .OldDeviceUnavailable = type {
                        wself.pause()
                        wself.delegate.videoView(shouldTogglePlayerButtonIconIsPause: false)
                    }
                }
            }
            .addDisposableTo(self.disposeBag)
    }
}