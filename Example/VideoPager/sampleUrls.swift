//
//  sampleUrls.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 2016/09/23.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


/**
 ONLINE
 */
private let onlineSampleUrls_str = [
    "http://techslides.com/demos/sample-videos/small.mp4",
    "http://www.sample-videos.com/video/mp4/360/big_buck_bunny_360p_50mb.mp4",
    "http://www.sample-videos.com/video/mp4/480/big_buck_bunny_480p_20mb.mp4",
    "http://www.sample-videos.com/video/mp4/240/big_buck_bunny_240p_50mb.mp4",
]
let onlineSampleUrls: [NSURL ] = {
    onlineSampleUrls_str.flatMap { NSURL(string: $0) }
}()


/**
 LOCAL
 */
private let localVideoFiles: [(name: String, videoExt: String)] = [
    ("balloon", "mp4"),
    ("cat_piano", "mp4"),
    ("disney", "mp4"),
    ("cat_short", "mp4"),
    ("note_3sec", "mp4"),
]
let localSampleVideoUrls: [NSURL] = {
    localVideoFiles.flatMap {
        guard let path = NSBundle.mainBundle().pathForResource($0.name, ofType: $0.videoExt) else {
            return nil
        }
        return NSURL(fileURLWithPath: path)
    }
}()
let localSampleThumbnailNames: [String] = {
    localVideoFiles.map { $0.name }
}()