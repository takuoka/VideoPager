//
//  makeCircleImage.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 2016/09/26.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

func makeCircleImage(color: UIColor = UIColor.whiteColor(), size: CGFloat) -> UIImage {
    let rect = CGRectMake(0, 0, size, size)
    let cgSize = CGSize(width: size, height: size)
    UIGraphicsBeginImageContextWithOptions(cgSize, false, 0)
    UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: cgSize), cornerRadius: size / 2).addClip()
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
