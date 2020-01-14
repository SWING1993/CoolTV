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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var resources = ["央视高清频道", "地方高清频道", "CIBN官方频道", "影视轮播频道"]
    var channelNames: [String] = []
    var channelDataSourcce: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func setupLoadData(resource: String) {
        channelNames.removeAll()
        channelDataSourcce.removeAll()
        
        let path = Bundle.main.path(forResource: resource, ofType: "txt")
        let url = URL(fileURLWithPath: path!)
        do {
            let content = try NSString.init(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
            let array = content.components(separatedBy: "\n")
            var titles: [String] = []
            var urlStrings: [String] = []
            for str in array {
                if str.contains(",") {
                    let item = str.components(separatedBy: ",")
                    if let title = item.first {
                        titles.append(title)
                    }
                    if let url = item.last {
                        urlStrings.append(url)
                    }
                }
            }
            
            for index in 0 ..< urlStrings.count {
                let title = titles[index]
                let urlString = urlStrings[index]
                channelDataSourcce[title] = urlString
                
            }
            
            var names: [String] = []
            for key in channelDataSourcce.keys {
                names.append(key)
            }
            self.channelNames = names.sorted(by: <)
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        } catch _ {
            showAlert(title: "", message: "读取数据时出现错误")
        }
    }
    
    func play(url: URL) {
        let item = AVPlayerItem.init(url: url)
        let avPlayerViewController = SWAVPlayerViewController()
        avPlayerViewController.player = AVPlayer.init(playerItem: item)
        avPlayerViewController.videoGravity = .resize
        avPlayerViewController.player?.play()
        self.present(avPlayerViewController, animated: true, completion: nil)
    }
    
    
    func showAlert(title:String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(ok)
        alertController.show(self, sender: nil)
    }
    
}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // section数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // 每个section的cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resources.count
    }
    
    // 填充每个cell的内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = resources[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        //        if let prevIndexPath = context.previouslyFocusedIndexPath {
        //        }
        if let nextIndexPath = context.nextFocusedIndexPath {
            self.setupLoadData(resource: self.resources[nextIndexPath.row])
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.channelNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SWChannelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SWChannelCell
        cell.backGroudView.layer.cornerRadius = 8
        cell.channelLabel.text = channelNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let channelName = channelNames[indexPath.row]
        if let urlString: String = channelDataSourcce[channelName] {
            if let url = URL.init(string: urlString) {
                play(url: url)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let prevIndexPath = context.previouslyFocusedIndexPath {
            print("prev")
            print(prevIndexPath)
            let cell: SWChannelCell = collectionView.cellForItem(at: prevIndexPath) as! SWChannelCell
            coordinator.addCoordinatedAnimations({
              UIView.animate(withDuration: UIView.inheritedAnimationDuration) {
                cell.backGroudView.backgroundColor = UIColor.tertiaryLabel
                cell.channelLabel.textColor = .white
              }
            }, completion: nil)
        }
        
        if let nextIndexPath = context.nextFocusedIndexPath {
            print("next:")
            print(nextIndexPath)
            let cell: SWChannelCell = collectionView.cellForItem(at: nextIndexPath) as! SWChannelCell
            coordinator.addCoordinatedAnimations({
              UIView.animate(withDuration: UIView.inheritedAnimationDuration) {
                cell.backGroudView.backgroundColor = UIColor.white
                cell.channelLabel.textColor = .black
              }
            }, completion: nil)
            
        }
    }
    
}
