//
//  VideoPagerCustomCell.swift
//  Pods
//
//  Created by Takuya Okamoto on 2016/09/19.
//
//

import UIKit
import RxSwift

@objc public protocol VideoPagerCustomUI {
    
    optional var playIcon: UIImage { get }
    optional var pauseIcon: UIImage { get }
    optional var playButton: UIButton! { get }

    optional var playSpeedButton: UIButton! { get }
    optional var speedRateList: [Float] { get }

    optional var frontSkipButton: UIButton! { get }
    optional var backSkipButton: UIButton! { get }
    
    optional var progressView: UIProgressView! { get }
    optional var currentTimeLabel: UILabel! { get }
    optional var remainTimeLabel: UILabel! { get }
    optional var activityIndicator: UIActivityIndicatorView! { get }
    
    optional var seekSlider: UISlider! { get }
    
    optional var topShadowHeight: CGFloat { get }
    optional var bottomShadowHeight: CGFloat { get }
    optional var shadowOpacity: CGFloat { get }
    
    optional var fadeEnabledViews: [UIView] { get }
}

// MARK - Internal Extensions

internal extension VideoPagerCell {
    
    func changeSpeedRateOfCustomUI() {
        guard let
            currentRate = speedRate,
            customUI = self as? VideoPagerCustomUI,
            rateList = customUI.speedRateList
            else { return }
        var currentIndex = -1
        for i in 0..<rateList.count {
            if rateList[i] == currentRate {
                currentIndex = i
                break
            }
        }
        var nextIndex = currentIndex + 1
        if nextIndex >= rateList.count {
            nextIndex = 0
        }
        speedRate = rateList[nextIndex]
    }
}

// MARK: - Shadow

internal extension VideoPagerCell {
    
    func setupShadowsOfCustomUI() {
        guard let customUI = self as? VideoPagerCustomUI else { return }
        let screenSize = UIScreen.mainScreen().bounds.size
        if let topShadowHeight = customUI.topShadowHeight {
            let topShadowLayer = CAGradientLayer.makeShadowLayer(
                size: CGSize(
                    width: screenSize.width,
                    height: topShadowHeight
                ),
                opacity: customUI.shadowOpacity ?? 0.2
            )
            topShadowView.layer.addSublayer(topShadowLayer)
            middleLayerView.addSubview(topShadowView)
        }
        if let bottomShadowHeight = customUI.bottomShadowHeight {
            let bottomShadowLayer = CAGradientLayer.makeShadowLayer(
                size: CGSize(
                    width: screenSize.width,
                    height: bottomShadowHeight
                ),
                opacity: customUI.shadowOpacity ?? 0.2,
                downDirection: false
            )
            bottomShadowView.layer.addSublayer(bottomShadowLayer)
            middleLayerView.addSubview(bottomShadowView)
        }
    }
    
    func layoutShadowViewsOfCustomUI() {
        guard let customUI = self as? VideoPagerCustomUI else { return }
        if let topShadowHeight = customUI.topShadowHeight {
            topShadowView.frame = CGRect(
                x: 0,
                y: 0,
                width: self.frame.width,
                height: topShadowHeight
            )
        }
        if let bottomShadowHeight = customUI.bottomShadowHeight {
            bottomShadowView.frame = CGRect(
                x: 0,
                y: self.frame.height - bottomShadowHeight,
                width: self.frame.width,
                height: bottomShadowHeight
            )
        }
    }
}

private extension CAGradientLayer {
    
    static func makeShadowLayer(size size: CGSize, opacity: CGFloat, color: UIColor = UIColor.blackColor(), downDirection: Bool = true) -> CAGradientLayer {
        let shadowFrame = CGRect(origin: CGPoint.zero, size: size)
        let shadowLayer = CAGradientLayer.makeShadowLayer(frame: shadowFrame, opacity: opacity, color: color, downDirection: downDirection)
        return shadowLayer
    }
    
    static func makeShadowLayer(frame frame: CGRect, opacity: CGFloat, color: UIColor, downDirection: Bool = false) -> CAGradientLayer {
        let shadowLayer = CAGradientLayer()
        shadowLayer.frame = frame
        shadowLayer.shadowRadius = 8.0
        let percentages = Array(0...100).filter { $0 % 2 == 0 }
        let alphas = percentages.map { (percent: Int) -> CGFloat in CGFloat(percent) * 0.01 }
        var colors: [CGColor] = alphas.map { color.colorWithAlphaComponent($0 * opacity).CGColor }
        if downDirection {
            colors = colors.reverse()
        }
        shadowLayer.colors = colors
        shadowLayer.locations = alphas
        return shadowLayer
    }
}