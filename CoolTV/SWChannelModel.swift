//
//  SWChannelModel.swift
//  CoolTV
//
//  Created by YZL-SWING on 2020/1/15.
//  Copyright © 2020 SWING. All rights reserved.
//

import UIKit

class SWChannelModel: NSObject {
    
    var title = ""
    var subChannels: [SWSubChannelModel] = []

}


class SWSubChannelModel: NSObject {
    
    var name = ""
    var url = ""

}
