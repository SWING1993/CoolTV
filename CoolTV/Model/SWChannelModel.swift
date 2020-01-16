//
//  SWChannelModel.swift
//  CoolTV
//
//  Created by YZL-SWING on 2020/1/15.
//  Copyright © 2020 SWING. All rights reserved.
//

import UIKit
 
class SWChannelModel: HandyJSON {
    
    var title = ""
    var subChannels: [SWSubChannelModel] = []
    
    required init() {}
}


class SWSubChannelModel: HandyJSON {
    
    var name = ""
    var url = ""

    required init() {}
}
