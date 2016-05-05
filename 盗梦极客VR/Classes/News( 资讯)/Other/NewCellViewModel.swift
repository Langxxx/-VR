//
//  NewCellViewModel.swift
//  盗梦极客VR
//
//  Created by wl on 4/26/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

typealias NewsCellPresentable = protocol<TopImageViewPresentable, TitlePresentable, ExcerptPresentable, TimePresentable, ReplyCountPresentable>

struct NewsCellViewModel: NewsCellPresentable {
     /// 图片URL
    var URL: String
     /// 标题
    var titleText: String
     /// 新闻简介
    var excerptText: String
     /// 发布时间
    var timeText: String
     /// 跟帖数
    var replyCountText: String
    
    init(model: NewsModel) {
        URL = model.listThuUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "!spc.png"
        titleText = model.title
        excerptText = model.excerpt
        timeText = model.date.componentsSeparatedByString(" ").first!
        replyCountText = model.customFields.discourseCommentsCount.first ?? "0"
    }
}

