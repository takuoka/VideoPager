//
//  VideoPagerCell.swift
//  PlayerPagingCollectionView
//
//  Created by Takuya Okamoto on 2016/08/14.
//  Copyright © 2016 Takuya Okamoto. All rights reserved.
//

import UIKit

/// please override this class to create your cell
public class VideoPagerCell: UICollectionViewCell {
    
    private let playerView = PlayerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    public func initialize() {
        playerView.delegate = self
        contentView.insertSubview(playerView, atIndex: 0)
    }
    
    /// please override
    public func didFailedToPlay() {
    }

    /// please override
    public func didEndPlayback() {
    }

    func activate(url: NSURL) {
        playerView.setUrlAndPlay(url)
    }
    
    func deactivate() {
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        playerView.frame = contentView.bounds
    }
}

extension VideoPagerCell: PlayerViewDelegate {
    
    func playerView(didFailedToPlay view: PlayerView) {
        self.didFailedToPlay()
    }
    
    func playerView(didEndPlayback view: PlayerView) {
        self.didEndPlayback()
    }
}


// MARK: - bridging property
extension VideoPagerCell {
    
    public var playIcon: UIImage {
        set {
            playerView.playIcon = newValue
        }
        get {
            return playerView.playIcon
        }
    }
    
    public var pauseIcon: UIImage {
        set {
            playerView.pauseIcon = newValue
        }
        get {
            return playerView.pauseIcon
        }
    }
}