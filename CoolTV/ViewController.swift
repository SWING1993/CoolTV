//
//  ViewController.swift
//  CoolTV
//
//  Created by 宋国华 on 2020/1/13.
//  Copyright © 2020 SWING. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var button: UIButton!
    
    let dataSouce = ["浙江TV", "湖南tv", "CCtv"]

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        UICollectionView
    
    }
    
    

    @IBAction func click(_ sender: Any) {
        let avPlayerViewController = AVPlayerViewController()
        avPlayerViewController.player = AVPlayer.init(url: URL.init(string: "http://111.13.111.167/otttv.bj.chinamobile.com/PLTV/88888888/224/3221226338/1.m3u8")!)
//        avPlayerViewController.videoGravity = .resize
        avPlayerViewController.player?.play()
        self.present(avPlayerViewController, animated: true, completion: nil)
    }
    
    @IBAction func xx(_ sender: Any) {
    
    }
    

}

