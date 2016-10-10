//
//  VideoPagerCell+Bridging.swift
//  Pods
//
//  Created by Takuya Okamoto on 2016/09/19.
//
//

import UIKit

// MARK: - bridging of playerView

extension VideoPagerCell {
    
    public func pause(bySystem bySystem: Bool = false) {
        playerView.pause(bySystem: bySystem)
    }
    
    public func stop() {
        playerView.stop()
    }
    
    public func playFromCurrentTime() {
        playerView.playFromCurrentTime()
    }
    
    public func seek(value: Double) {
        playerView.seek(value)
    }
    
    public func seekToTime(time: NSTimeInterval) {
        playerView.seekToTime(time)
    }
    
    public func skipFront() {
        playerView.skipFront()
    }
    
    public func skipBack() {
        playerView.skipBack()
    }
    
    func restorePlayer() {
        playerView.restorePlayer()
    }
    
    public var middleLayerView: UIView {
        get {
            return playerView.middleLayerView
        }
    }
    
    public var bottomLayerView: UIView {
        get {
            return playerView.bottomLayerView
        }
    }
    
    public var videoGravity: String? {
        get {
            return playerView.videoGravity
        }
        set {
            playerView.videoGravity = newValue
        }
    }
    
    public var currentTime: NSTimeInterval { return playerView.currentTime }
    
    public var duration: NSTimeInterval { return playerView.duration }
    
    public var speedRate: Float? {
        get {
            return playerView.speedRate
        }
        set {
            playerView.speedRate = newValue
        }
    }
    
    /// default is true
    public var enableFadeAnimation: Bool {
        set {
            playerView.enableFadeAnimation = newValue
        }
        get {
            return playerView.enableFadeAnimation
        }
    }
    
    public var pausedBySystem: Bool { return playerView.pausedBySystem }
    
    public var pausedByUser: Bool { return playerView.pausedByUser }
}