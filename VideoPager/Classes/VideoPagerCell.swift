//
//  VideoPagerCell.swift
//  PlayerPagingCollectionView
//
//  Created by Takuya Okamoto on 2016/08/14.
//  Copyright © 2016 Takuya Okamoto. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

protocol VideoPagerCellDelegate: class {
    func videoPagerCell(didPlayToEndTime cell: VideoPagerCell)
    func videoPagerCell(didFailedToPlay cell: VideoPagerCell)
}

/// please override if you create your cell
public class VideoPagerCell: UICollectionViewCell {
    
    public let thumbnailView = UIImageView()
    public let topShadowView = UIView()
    public let bottomShadowView = UIView()

    let playerView = PlayerView()

    weak var delegate: VideoPagerCellDelegate!

    private let fadeoutHelper = ComponentsFadeoutHelper()

    private var isEndedPlay = false
    private var isFirstLayout = true
    private var isPlayButtonIconIsPause = true

    private var disposeBag = DisposeBag()

    private var customUI: VideoPagerCustomUI? { return self as? VideoPagerCustomUI }
    
    // MARK: - initialize

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
        middleLayerView.insertSubview(thumbnailView, atIndex: 0)
        thumbnailView.contentMode = .ScaleAspectFit
    }
    
    private func setupFadeoutHelper() {
        guard let fadeViews = customUI?.fadeEnabledViews else { return }
        fadeoutHelper.fadeViews = fadeViews
        fadeoutHelper.setTimerToFadeOut()
    }

    // MARK: - public method
    
    public func playOrPause() {
        isPlayButtonIconIsPause ? pause() : playFromCurrentTime()
    }
    
    // MARK: - life cycle

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
        playerView.resetControlView()
        toggleEnabledOfCustomSkipButtons(front: false, back: false)
        setTitleOfCustomSpeedButton(VideoView.sharedPlayer.speedRate)
        fadeoutHelper.fadeIn(animated: false)
        thumbnailView.alpha = 1
        customUI?.progressView?.setProgress(0, animated: false)
        customUI?.seekSlider?.value = 0
        customUI?.backSkipButton?.enabled = false
    }
    
    public func willLayoutSubViewsFirst() {
        isFirstLayout = false
        toggleEnabledCustomControlUI(false)
        setupShadowsOfCustomUI()
        customUI?.progressView?.setProgress(0, animated: false)
        customUI?.seekSlider?.value = 0
        customUI?.backSkipButton?.enabled = false
    }
    
    public override func layoutSubviews() {
        if isFirstLayout {
            willLayoutSubViewsFirst()
        }
        super.layoutSubviews()
        playerView.frame = contentView.bounds
        thumbnailView.frame = contentView.bounds
        layoutShadowViewsOfCustomUI()
    }
    
    // MARK: - activate / deactivate
    
    func activate(url: NSURL) {
        playerView.setUrlAndPlay(url)
        playerDidSetUrl()
        setTitleOfCustomSpeedButton(VideoView.sharedPlayer.speedRate)
        setupFadeoutHelper()
    }
    
    func deactivate() {
    }

    // MARK: - player life cycle
    
    public func preferVideoFillMode() -> VideoPagerFillMode {
        return .AspectFit
    }
    
    public func playerDidSetUrl() {
        self.videoGravity = preferVideoFillMode().string
    }
    
    public func playerDidStartPlayback() {
        UIView.animateWithDuration(0.3, delay: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.thumbnailView.alpha = CGFloat(0)
            },
            completion: { _ in }
        )
    }
    
    public func playerDidPlayToEndTime() {
    }

    public func playerWillEndPlay() {
    }
    
    func playerWillEndPlayIfNotEnded() {
        if !isEndedPlay {
            isEndedPlay = true
            playerWillEndPlay()
        }
    }

    public func willDisplay() {
        toggleIndicatorOfCustomUI(true)
        setTapEventsForCustomUI()
        fadeoutHelper.setTimerToFadeOut()
    }
    
    public func didAppear() {
    }
    
    public func didTapCell() {
        fadeoutHelper.toggle()
    }
    
    public func viewControllerDidAppearWhenCellIsActive() {
    }
}

// MARK: - PlayerViewDelegate

extension VideoPagerCell: PlayerViewDelegate {
    
    func playerView(controlViewsShouldBeDisable disable: Bool) {
        toggleEnabledCustomControlUI(!disable)
    }
    
    func playerView(playButtonIconShouldBeChangeToPauseIcon isPauseButton: Bool) {
        isPlayButtonIconIsPause = isPauseButton
        if let customUI = customUI {
            let icon = isPauseButton ? customUI.pauseIcon : customUI.playIcon
            customUI.playButton?.setImage(icon, forState: .Normal)
        }
    }
    
    func playerView(didStartPlayback view: PlayerView) {
        playerDidStartPlayback()
        isEndedPlay = false
    }
    
    func playerView(didPlayToEndTime view: PlayerView) {
        playerDidPlayToEndTime()
        delegate.videoPagerCell(didPlayToEndTime: self)
    }
    
    func playerView(didFailedToPlay view: PlayerView) {
        delegate.videoPagerCell(didFailedToPlay: self)
    }
    
    func playerView(didChangeSpeedRate rate: Float) {
        setTitleOfCustomSpeedButton(rate)
    }
    
    func playerView(didChangeSkipEnabledState front: Bool, back: Bool) {
        toggleEnabledOfCustomSkipButtons(front: front, back: back)
    }
    
    func playerView(didChangeCurrentTime currentTime: NSTimeInterval, duration: NSTimeInterval) {
        guard let customUI = self.customUI else { return }
        let progress = Float(currentTime / duration)
        let remainTime = duration - currentTime
        customUI.progressView?.progress = progress
        customUI.seekSlider?.value = progress
        customUI.currentTimeLabel?.text = self.stringFromTimeInterval(currentTime)
        customUI.remainTimeLabel?.text = self.stringFromTimeInterval(remainTime)
    }
    
    func playerView(activityIndicatorShouldBeVisible visible: Bool) {
        toggleIndicatorOfCustomUI(visible)
    }
}

// MARK: - tap events of Custom UI

extension VideoPagerCell {
    
    private func setTapEventsForCustomUI() {
        
        guard let customUI = customUI else { return }
        
        customUI.playButton?.rx_tap.subscribeNext { [weak self] _ in
            guard let `self` = self else { return }
            self.playOrPause()
            self.fadeoutHelper.setTimerToFadeOut()
            }
            .addDisposableTo(disposeBag)
        
        customUI.frontSkipButton?.rx_tap.subscribeNext { [weak self] _ in
            guard let `self` = self else { return }
            self.skipFront()
            self.fadeoutHelper.setTimerToFadeOut()
            }
            .addDisposableTo(disposeBag)
        
        customUI.backSkipButton?.rx_tap.subscribeNext { [weak self] _ in
            guard let `self` = self else { return }
            self.skipBack()
            self.fadeoutHelper.setTimerToFadeOut()
            }
            .addDisposableTo(disposeBag)
        
        customUI.playSpeedButton?.rx_tap.subscribeNext { [weak self] _ in
            guard let `self` = self else { return }
            self.changeSpeedRateOfCustomUI()
            self.fadeoutHelper.setTimerToFadeOut()
            }
            .addDisposableTo(disposeBag)
        
        if let slider = customUI.seekSlider {
            
            slider.rx_controlEvent(.TouchDown).subscribeNext { [weak self] _ in
                guard let `self` = self else { return }
                self.pause(bySystem: true)
                self.fadeoutHelper.setTimerToFadeOut()
                }
                .addDisposableTo(disposeBag)
            
            slider.rx_controlEvent(.ValueChanged).subscribeNext { [weak self] _ in
                guard let `self` = self else { return }
                self.seek(Double(slider.value))
                self.fadeoutHelper.setTimerToFadeOut()
                }
                .addDisposableTo(disposeBag)
            
            let touchUpOutside = slider.rx_controlEvent(.TouchUpOutside)
            let touchUpInside = slider.rx_controlEvent(.TouchUpInside)
            Observable
                .of(touchUpOutside, touchUpInside)
                .merge()
                .subscribeNext { [weak self] _ in
                    guard let `self` = self else { return }
                    if self.pausedByUser == false {
                        self.playFromCurrentTime()
                        self.fadeoutHelper.setTimerToFadeOut()
                    }
                }
                .addDisposableTo(disposeBag)
        }
    }
}

// MARK: - Private Methods

extension VideoPagerCell {
    
    private func toggleEnabledCustomControlUI(enabled: Bool) {
        guard let customUI = customUI else { return }
        customUI.playButton?.enabled = enabled
        customUI.playSpeedButton?.enabled = enabled
    }
    
    private func setTitleOfCustomSpeedButton(rate: Float) {
        customUI?.playSpeedButton?.setTitle("x\(rate)", forState: .Normal)
    }
    
    private func toggleEnabledOfCustomSkipButtons(front front: Bool, back: Bool) {
        guard let customUI = customUI else { return }
        customUI.frontSkipButton?.enabled = front
        customUI.backSkipButton?.enabled = back
    }
    
    private func toggleIndicatorOfCustomUI(show: Bool) {
        guard let indicator = customUI?.activityIndicator else { return }
        show ? indicator.startAnimating() : indicator.stopAnimating()
        indicator.hidden = !show
    }
    
    private func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = interval / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

public enum VideoPagerFillMode {
    case AspectFill
    case AspectFit
    
    var string: String {
        switch self {
        case .AspectFill:
            return AVLayerVideoGravityResizeAspectFill
        case .AspectFit:
            return AVLayerVideoGravityResizeAspect
        }
    }
}