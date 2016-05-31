//
//  ReplyCellViewModel.swift
//  盗梦极客VR
//
//  Created by wl on 5/11/16.
//  Copyright © 2016 wl. All rights reserved.
//   ReplyCell的Viewmodel，负责 ReplyCell显示逻辑

import Foundation

typealias ReplyCellPresentable = protocol<TopImageViewPresentable, TitlePresentable, TimePresentable, ExcerptPresentable>

struct ReplyCellViewModel: ReplyCellPresentable {
    /// 图片URL
    var URL: String
    /// 这里是用户名
    var titleText: String
    /// 回复内容
    var excerptText: String
    /// 回复时间
    var timeText: String
    
    let avatarIconSize = "64"
    
    
    init(model: Post) {
        URL = model.avatarTemplate.stringByReplacingOccurrencesOfString("{size}", withString: avatarIconSize)
        titleText = model.name
        excerptText = try! RegexHelper.replaceHtml(model.cooked)
        timeText = model.createdAt.componentsSeparatedByString("T").first!
    }
}