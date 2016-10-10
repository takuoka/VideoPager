//
//  ComponentsFadeoutHelper.swift
//  Pods
//
//  Created by Takuya Okamoto on 2016/09/23.
//
//

import UIKit

class ComponentsFadeoutHelper {
    
    var fadeViews: [UIView] = []
    var autoDuration: NSTimeInterval = 0.75
    var duration: NSTimeInterval = 0.2
    var fadeoutTimerDelay: NSTimeInterval = 1.5
    private var fadeoutTimer: NSTimer?
    
    func toggle() {
        guard fadeViews.count > 0 else { return }
        guard let firstView = fadeViews.first else { return }
        firstView.alpha == 0 ? self.fadeIn() : self.fadeOut(duration: duration)
    }
    
    func fadeOut(duration duration: NSTimeInterval? = nil) {
        guard fadeViews.count > 0 else { return }
        fadeTo(0, duration: duration ?? self.duration)
    }
    
    func fadeIn(animated animated: Bool = true) {
        guard fadeViews.count > 0 else { return }
        guard animated else {
            fadeViews.forEach { $0.alpha = 1 }
            setTimerToFadeOut()
            return
        }
        self.fadeTo(1, duration: duration) { [weak self] in
            self?.setTimerToFadeOut()
        }
    }
    
    func setTimerToFadeOut() {
        guard fadeViews.count > 0 else { return }
        self.fadeoutTimer?.invalidate()
        self.fadeoutTimer = NSTimer.schedule(delay: fadeoutTimerDelay) { [weak self] _ in
            guard let `self` = self else { return }
            self.fadeOut(duration: self.autoDuration)
        }
    }
    
    private func fadeTo(toAlpha: CGFloat, duration: NSTimeInterval, completion:(() -> Void)? = nil) {
        UIView.animateWithDuration(duration,
            animations: {
                self.fadeViews.forEach { $0.alpha = toAlpha }
            },
            completion: { _ in
                completion?()
            }
        )
    }
}
