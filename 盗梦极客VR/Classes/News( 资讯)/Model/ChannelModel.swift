//
//  ChannelModel.swift
//  盗梦极客VR
//
//  Created by wl on 4/25/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

struct ChannelModel {
    let title: String
    let URL: String
    
    init(dict: [String: String]) {
        title = dict["title"]!
        URL = dict["URL"]!
    }
}

extension ChannelModel {
    /**
     从plist文件获得频道信息
     
     - returns: 频道信息模型
     */
    static func getChannelModels() -> [ChannelModel] {
        let path = NSBundle.mainBundle().pathForResource("ChannelConfig.plist", ofType: nil)!
        let array = NSArray(contentsOfFile: path) as! [[String: String]]
        
        return array.map { ChannelModel(dict: $0) }
    }

}

