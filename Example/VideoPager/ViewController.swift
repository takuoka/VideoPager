//
//  ViewController.swift
//  VideoPager
//
//  Created by Takuya Okamoto on 08/17/2016.
//  Copyright (c) 2016 Takuya Okamoto. All rights reserved.
//

import UIKit
import VideoPager

class ViewController: UIViewController {

    let urls = sampleUrls.flatMap { NSURL(string: $0) }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let cellNib = UINib(nibName: "SampleCell", bundle: nil)
        let videoPager = VideoPagerViewController(videoPagerCellNib: cellNib)
        videoPager.delegate = self
        self.presentViewController(videoPager, animated: true, completion: nil)
        
        videoPager.updateUrls(urls)
    }
}

extension ViewController: VideoPagerViewControllerDelegate {

    func videoPagerViewController(videoPagerViewController: VideoPagerViewController, configureCell cell: VideoPagerCell, index: Int) {
        if let cell = cell as? SampleCell {
            cell.label.text = urls[index].path
        }
    }
    
    func videoPagerViewController(videoPagerViewController: VideoPagerViewController, didSelectItemAtIndexPath index: Int) {
        // do something
    }
}

let sampleUrls = [
    "http://techslides.com/demos/sample-videos/small.mp4",
    "https://video.twimg.com/ext_tw_video/721247018774085632/pu/vid/640x360/6Yj3DNh9oOTor6th.mp4",
    "https://video.twimg.com/ext_tw_video/721220371433832448/pu/vid/636x360/m8DR0F__btKishSH.mp4",
    "https://video.twimg.com/ext_tw_video/721196542280015872/pu/vid/640x360/zuH4lcQd2AE9_-IV.mp4",
    "https://video.twimg.com/ext_tw_video/720495622500048896/pu/vid/640x360/FaLbFl7U7VHKaG0n.mp4",
    "https://video.twimg.com/ext_tw_video/720397787020402691/pu/vid/632x360/cvGp1PTm17mLfXv7.mp4",
    "https://video.twimg.com/ext_tw_video/720138283821481984/pu/vid/640x360/X8cibvn7_Z7p2cZU.mp4",
    "https://video.twimg.com/ext_tw_video/720109348836519936/pu/vid/640x360/5Y25WLyghSBkb2Jd.mp4",
    "https://video.twimg.com/ext_tw_video/719802351041835008/pu/vid/640x360/Kc8yBFghDDkNueob.mp4",
    "https://video.twimg.com/ext_tw_video/719775894110400512/pu/vid/640x360/MWBMeQM5N9bbBFGg.mp4",
    "https://video.twimg.com/ext_tw_video/719705685408247810/pu/vid/640x360/VPeZ8sH2eIVvvvvI.mp4",
    "http://www.sample-videos.com/video/mp4/360/big_buck_bunny_360p_50mb.mp4",
    "http://www.sample-videos.com/video/mp4/480/big_buck_bunny_480p_20mb.mp4",
    "http://www.sample-videos.com/video/mp4/240/big_buck_bunny_240p_50mb.mp4",
]
