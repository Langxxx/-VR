//
//  ReplyTitleCellViewModel.swift
//  盗梦极客VR
//
//  Created by wl on 5/11/16.
//  Copyright © 2016 wl. All rights reserved.
//   ReplyTitleCell的Viewmodel，负责 ReplyTitleCell显示逻辑

import Foundation
import DTCoreText

protocol HtmlStringPresentable {
    var htmlText: String { get }
    
    func confightmlTextView (view: UIView)
}

extension HtmlStringPresentable {
    func confightmlTextView(view: UIView) {
        let attributedLabel = view as! DTAttributedTextCell
        attributedLabel.setHTMLString(htmlText)
    }
}
typealias ReplyTitleCellPresentable = protocol<TopImageViewPresentable, TitlePresentable, TimePresentable>

struct ReplyTitleCellViewModel: ReplyTitleCellPresentable {
    /// 图片URL
    var URL: String
    /// 这里是用户名
    var titleText: String
    /// 回复时间
    var timeText: String
    
    let avatarIconSize = "64"
    
    init(model: Post) {
        URL = model.avatarTemplate.stringByReplacingOccurrencesOfString("{size}", withString: avatarIconSize)
        titleText = model.name
        timeText = model.createdAt.componentsSeparatedByString("T").first!
    }
}