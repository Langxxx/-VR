//
//  ReplyCellViewModel.swift
//  盗梦极客VR
//
//  Created by wl on 5/11/16.
//  Copyright © 2016 wl. All rights reserved.
//   ReplyCell的Viewmodel，负责 ReplyCell显示逻辑

import Foundation
import DTCoreText

protocol HtmlStringPresentable {
    var htmlText: String { get }
    
    func confightmlTextView (view: UIView)
}

extension HtmlStringPresentable {
    func confightmlTextView(view: UIView) {
        let attributedLabel = view as! CoreTextView
        let data = ("<style>body{color:gray;}p, li {font-family:\"Avenir Next\";font-size:14px;line-height:15px;}a {color: #f25d3c;text-decoration: none;}</style>" + htmlText).dataUsingEncoding(NSUTF8StringEncoding)
        attributedLabel.attributedString = NSAttributedString(HTMLData: data, documentAttributes: nil)
    }
}
typealias ReplyCellPresentable = protocol<TopImageViewPresentable, TitlePresentable, TimePresentable, ExcerptPresentable, HtmlStringPresentable>

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
    var htmlText: String
    
    init(model: Post) {
        URL = model.avatarTemplate.stringByReplacingOccurrencesOfString("{size}", withString: avatarIconSize)
        titleText = model.name
        excerptText = try! RegexHelper.replaceHtml(model.cooked)
        timeText = model.createdAt.componentsSeparatedByString("T").first!
        htmlText = model.cooked
    }
}