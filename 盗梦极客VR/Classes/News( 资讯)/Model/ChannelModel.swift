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
    let taxonomies: [Taxonomy]
    let type: String
    
    init(dict: [String: AnyObject]) {
        title = dict["title"] as! String
        URL = dict["URL"] as! String
        let terms = dict["terms"] as! [[String: String]]
        taxonomies = terms.map { Taxonomy(dict: $0) }
        type = dict["type"] as! String
    }
}
/**
 *  频道下的字分类
 */
struct Taxonomy {
        /// 分类ID，用来请求数据
    let id: String
        /// web端 url里的链接
    let slug: String
        /// 分类名
    let title: String
        /// 描述
    let description: String
        /// 总帖子
    let postCount: String
    
    init(dict: [String: String]) {
        id = dict["id"]!
        slug = dict["slug"]!
        title = dict["title"]!
        description = dict["description"]!
        postCount = dict["postCount"]!
    }
}

extension ChannelModel {
    /**
     从plist文件获得频道信息
     
     - returns: 频道信息模型
     */
    static func getChannelModels() -> [ChannelModel] {
        let path = NSBundle.mainBundle().pathForResource("ChannelConfig.plist", ofType: nil)!
        let array = NSArray(contentsOfFile: path) as! [[String: AnyObject]]
        
        return array.map { ChannelModel(dict: $0) }
    }

}

