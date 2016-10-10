//
//  delay.swift
//  Pods
//
//  Created by Takuya Okamoto on 2016/08/24.
//
//

import Foundation

func delay(delay: Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}