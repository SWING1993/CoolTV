//
//  SWAVPlayerViewController.swift
//  CoolTV
//
//  Created by YZL-SWING on 2020/1/14.
//  Copyright © 2020 SWING. All rights reserved.
//

import UIKit
import AVKit

class SWAVPlayerViewController: AVPlayerViewController {
    
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(tapped))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)];
        self.view.addGestureRecognizer(tapRecognizer)
        self.videoGravity = .resize
        self.isPlaying = true
    }
    
    @objc
    func tapped() {
        print("tapped")
        if self.isPlaying {
            self.player?.pause()
        } else {
            self.player?.play()
        }
        self.isPlaying = !self.isPlaying
    }

}
