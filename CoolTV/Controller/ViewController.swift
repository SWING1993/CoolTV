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
    
    var didSelectRow = 0
    var channels: [SWChannelModel] = []
    
    let responseJsonKey = "responseJson"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLocalData()
        loadNetworkResources()
    }
    
    func play(url: URL) {
        let item = AVPlayerItem.init(url: url)
        let avPlayerViewController = SWAVPlayerViewController()
        avPlayerViewController.player = AVPlayer.init(playerItem: item)
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
    
    func loadNetworkResources() {
        AF.request("http://106.54.209.203:8080/").responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    self.channels.removeAll()
                    let json = String.init(data: data, encoding: .utf8)
                    if let models = [SWChannelModel].deserialize(from: json) {
                        self.channels = models as! [SWChannelModel]
                    }
                    self.tableView.reloadData()
                    UserDefaults.standard.set(json, forKey: self.responseJsonKey)
                }
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
    
    func loadLocalData() {
        if let json = UserDefaults.standard.string(forKey: responseJsonKey) {
            if let models = [SWChannelModel].deserialize(from: json) {
                self.channels = models as! [SWChannelModel]
            }
        } else {
            let resources = ["央视高清频道", "卫视高清频道", "虎牙影视轮播", "爱奇艺影视轮播"]
            var models: [SWChannelModel] = []
            for resource in resources {
                let path = Bundle.main.path(forResource: resource, ofType: "txt")
                let url = URL(fileURLWithPath: path!)
                do {
                    let content = try NSString.init(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
                    let channelModel = resolve(title: resource, content: content as String)
                    models.append(channelModel)
                } catch _ {
                    
                }
            }
            self.channels = models
        }
        self.tableView.reloadData()
    }
    
    func resolve(title: String, content: String)  -> SWChannelModel {
        let channelModel = SWChannelModel()
        channelModel.title = title
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
        var channelNames: [String] = []
        var channelDataSourcce: [String: String] = [:]
        for index in 0 ..< urlStrings.count {
            let title = titles[index]
            let urlString = urlStrings[index]
            channelDataSourcce[title] = urlString
        }
        var names: [String] = []
        for key in channelDataSourcce.keys {
            names.append(key)
        }
        channelNames = names.sorted(by: <)
        
        var subChannelModels: [SWSubChannelModel] = []
        for name in channelNames {
            let subChannelModel = SWSubChannelModel()
            subChannelModel.name = name
            if let url = channelDataSourcce[name] {
                subChannelModel.url = url
            }
            subChannelModels.append(subChannelModel)
        }
        channelModel.subChannels = subChannelModels
        return channelModel
    }
    
    //    func checkActivate() {
    //        let installKey = "install_date"
    //        let i = UserDefaults.standard.double(forKey: installKey)
    //        if i > 0 {
    //            let now = Date().timeIntervalSince1970
    //            print(now - i)
    //        } else {
    //            let installdate = Date().timeIntervalSince1970
    //            UserDefaults.standard.set(installdate, forKey: installKey)
    //        }
    //    }
}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // section数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // 每个section的cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channels.count
    }
    
    // 填充每个cell的内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.textColor = .white
        let channel = channels[indexPath.row]
        cell.textLabel?.text = channel.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let prevIndexPath = context.previouslyFocusedIndexPath {
            if let cell = tableView.cellForRow(at: prevIndexPath) {
                cell.textLabel?.textColor = .white
            }
        }
        if let nextIndexPath = context.nextFocusedIndexPath {
            if let cell = tableView.cellForRow(at: nextIndexPath) {
                cell.textLabel?.textColor = .black
            }
            self.didSelectRow = nextIndexPath.row
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if channels.count > self.didSelectRow {
            let channel = channels[self.didSelectRow]
            return channel.subChannels.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SWChannelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SWChannelCell
        cell.backGroudView.layer.cornerRadius = 8
        let channel = channels[self.didSelectRow]
        let subChannel = channel.subChannels[indexPath.row]
        cell.channelLabel.text = subChannel.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let channel = channels[self.didSelectRow]
        let subChannel = channel.subChannels[indexPath.row]
        if let url = URL.init(string: subChannel.url) {
            play(url: url)
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
            let cell: SWChannelCell = collectionView.cellForItem(at: prevIndexPath) as! SWChannelCell
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: UIView.inheritedAnimationDuration) {
                    cell.backGroudView.backgroundColor = UIColor.init(displayP3Red: 60.0/255.0, green: 60.0/255.0, blue: 67.0/255.0, alpha: 0.3)
                    cell.channelLabel.textColor = .white
                }
            }, completion: nil)
        }
        
        if let nextIndexPath = context.nextFocusedIndexPath {
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




