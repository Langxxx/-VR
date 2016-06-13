//
//  NewCellViewModel.swift
//  盗梦极客VR
//
//  Created by wl on 4/26/16.
//  Copyright © 2016 wl. All rights reserved.
//  NewsCell的Viewmodel，负责NewsCell显示逻辑

import Foundation

typealias NewsCellPresentable = protocol<TopImageViewPresentable, TitlePresentable, ExcerptPresentable, TimePresentable, ReplyCountPresentable, TagPresentable>

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
        /// 新闻类别(目前用于设备和视频)
    var tagString: String
    
    init(model: NewsModel, isActivity: Bool = false) {
        URL = model.listThuUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "!spc.png"
        titleText = model.title
        excerptText = model.excerpt.limitStringLenth(70)
        timeText = isActivity ? "开始时间：" + model.date.componentsSeparatedByString(" ").first! : model.date.componentsSeparatedByString(" ").first!
        replyCountText = model.customFields.discourseCommentsCount.first ?? "0"
        tagString = model.specialTag
    }
}

extension String {
    func limitStringLenth(lenth: Int) -> String {
        if self.characters.count > lenth {
            let index = self.startIndex.advancedBy(lenth)
            return self.substringToIndex(index) + "..."
        }else {
            return self
        }
    }
}