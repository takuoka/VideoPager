//
//  SeekBar.swift
//  PlayerPagingCollectionView
//
//  Created by Takuya Okamoto on 2016/08/14.
//  Copyright © 2016 Takuya Okamoto. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol SeekBarDelegate: class {
    func seekBar(didSlide value: Double)
    func seekBar(didTouchDown value: Double)
    func seekBar(didTouchUp value: Double)
}

class SeekBar: UIView {
    
    weak var delegate: SeekBarDelegate!
    
    private let slider: SeekSlider
    private let leftTimeLabel = UILabel()
    private let rightTimeLabel = UILabel()
    private let timerFont: UIFont
    private let timerTextColor: UIColor
    
    init(timerFont: UIFont, timerTextColor: UIColor, minimumTrackColor: UIColor, maximumTrackColor: UIColor, bufferProgressColor: UIColor) {
        self.timerFont = timerFont
        self.timerTextColor = timerTextColor
        self.slider = SeekSlider(minimumTrackColor: minimumTrackColor, maximumTrackColor: maximumTrackColor, bufferProgressColor: bufferProgressColor)
        super.init(frame: CGRect.zero)
        self.setupViews()
        // touch events
        self.slider.addTarget(self, action: #selector(self.dynamicType.sliderDidChangeValue), forControlEvents: .ValueChanged)
        self.slider.addTarget(self, action: #selector(self.dynamicType.sliderDidTouchDown), forControlEvents: .TouchDown)
        self.slider.addTarget(self, action: #selector(self.dynamicType.sliderDidTouchUpInside), forControlEvents: .TouchUpInside)
        self.slider.addTarget(self, action: #selector(self.dynamicType.sliderDidTouchUpOutside), forControlEvents: .TouchUpOutside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSeekValue(value: Double, animated: Bool) {
        self.slider.setValue(Float(value), animated: animated)
    }
    
    func setPlayingTimeLabelText(sec sec: Double, duration: Double) {
        leftTimeLabel.text = sec.toTimeString()
        rightTimeLabel.text = (duration - sec).toTimeString()
    }
    
    func setBufferingProgress(value: Double) {
        self.slider.setLoadingProgress(Float(value))
    }
}


// MARK: Touch Events
extension SeekBar {

    func sliderDidChangeValue() {
        delegate.seekBar(didSlide: Double(self.slider.value))
    }

    func sliderDidTouchDown() {
        delegate.seekBar(didTouchDown: Double(self.slider.value))
    }

    func sliderDidTouchUpInside() {
        delegate.seekBar(didTouchUp: Double(self.slider.value))
    }
    
    func sliderDidTouchUpOutside() {
        delegate.seekBar(didTouchUp: Double(self.slider.value))
    }
}

// MARK: - Design
extension SeekBar {
    
    private func setupViews() {
        self.addSubview(slider)
        self.addSubview(leftTimeLabel)
        self.addSubview(rightTimeLabel)
        
        let zeroText = 0.0.toTimeString()
        
        leftTimeLabel.text = zeroText
        leftTimeLabel.textColor = timerTextColor
        leftTimeLabel.font = timerFont
        leftTimeLabel.textAlignment = .Center
        
        rightTimeLabel.text = zeroText
        rightTimeLabel.textColor = timerTextColor
        rightTimeLabel.font = timerFont
        rightTimeLabel.textAlignment = .Center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelMargin: CGFloat = 8
        let labelBaselineAdjust: CGFloat = 0
        
        leftTimeLabel.sizeToFit()
        leftTimeLabel.center.y = (self.frame.size.height / 2) + labelBaselineAdjust
        leftTimeLabel.frame.size.width += labelMargin
        
        rightTimeLabel.sizeToFit()
        rightTimeLabel.frame.origin.x = slider.frame.maxX + labelMargin
        rightTimeLabel.center.y = (self.frame.size.height / 2) + labelBaselineAdjust
        rightTimeLabel.frame.size.width += labelMargin
        
        slider.frame.size.height = self.frame.size.height
        slider.frame.origin.x = leftTimeLabel.frame.size.width
        slider.frame.size.width = self.frame.size.width - leftTimeLabel.frame.size.width - rightTimeLabel.frame.size.width
    }
}

private extension Double {

    func toTimeString() -> String {
        if self.isNaN {
            return ""
        }
        let s: Int = Int(self % 60)
        let m: Int = Int((Int(self) - s) / 60)
        let str = String(format: "%d:%02d", m, s)
        return str
    }
}

private class SeekSlider: UISlider {
    
    private var progressBarLayer: ProgressBarLayer!
    private let thumbSize: CGFloat = 14
    private let barHeight: CGFloat = 1.0
    var loadingProgress: Float {
        return Float(self.progressBarLayer.strokeEnd)
    }
    
    init(minimumTrackColor: UIColor, maximumTrackColor: UIColor, bufferProgressColor: UIColor) {
        super.init(frame: CGRect.zero)
        self.minimumTrackTintColor = minimumTrackColor
        self.maximumTrackTintColor = maximumTrackColor
        self.progressBarLayer = ProgressBarLayer(lineColor: bufferProgressColor, lineWidth: self.barHeight)
        self.progressBarLayer.marginLeft = 2// adjust
        self.layer.addSublayer(self.progressBarLayer)
        self.setThumbImage(makeWhiteCircleImage(size: thumbSize), forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLoadingProgress(value: Float) {
        self.progressBarLayer.setProgress(value)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.progressBarLayer.frame.size = self.frame.size
        self.progressBarLayer.layoutSublayers()
    }
    
    // change height of UISlider's bar
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        let superBounds = super.trackRectForBounds(bounds)
        let customBounds = CGRect(origin: superBounds.origin, size: CGSize(width: superBounds.size.width, height: self.barHeight))
        return customBounds
    }
    
    private func makeWhiteCircleImage(color: UIColor = UIColor.whiteColor(), size: CGFloat) -> UIImage {
        let rect = CGRectMake(0, 0, size, size)
        let cgSize = CGSize(width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(cgSize, false, 0)
        UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: cgSize), cornerRadius: size / 2).addClip()
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

private class ProgressBarLayer: CAShapeLayer {
    
    var marginLeft: CGFloat = 0
    var marginRight: CGFloat = 0
    
    init(lineColor: UIColor, lineWidth: CGFloat) {
        super.init()
        self.fillColor = nil
        self.strokeColor = lineColor.CGColor
        self.lineWidth = lineWidth
        self.strokeStart = 0
        self.strokeEnd = 0
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(value: Float) {
        if value > 1 {
            self.strokeEnd = 1
        } else if value < 0 {
            self.strokeEnd = 0
        } else {
            self.strokeEnd = CGFloat(value)
        }
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let path = UIBezierPath()
        let y = (self.frame.height / 2) - self.lineWidth / 2
        path.moveToPoint(CGPoint(x: self.marginLeft, y: y))
        path.addLineToPoint(CGPoint(x: self.frame.width - (self.marginLeft + self.marginRight), y: y))
        self.path = path.CGPath
    }
}