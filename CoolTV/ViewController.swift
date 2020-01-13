//
//  ViewController.swift
//  CoolTV
//
//  Created by 宋国华 on 2020/1/13.
//  Copyright © 2020 SWING. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
     
    }
    
    

    @IBAction func click(_ sender: Any) {
        let avPlayerViewController = AVPlayerViewController()
        avPlayerViewController.player = AVPlayer.init(url: URL.init(string: "http://111.13.111.167/otttv.bj.chinamobile.com/PLTV/88888888/224/3221226338/1.m3u8")!)
        avPlayerViewController.videoGravity = .resize
        avPlayerViewController.player?.play()
        self.present(avPlayerViewController, animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
}

