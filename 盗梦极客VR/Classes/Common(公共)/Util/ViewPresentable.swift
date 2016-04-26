//
//  ViewDataSource.swift
//  盗梦极客VR
//
//  Created by wl on 4/26/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import SDWebImage

protocol TitlePresentable {
    var titleText: String { get }
    var titleColor: UIColor { get }
    var titleFont: UIFont { get }
    
    func configTitleLabel(label: UILabel)
}

extension TitlePresentable {
    var titleColor: UIColor {
        return UIColor.blackColor()
    }
    
    var titleFont: UIFont {
        return UIFont.systemFontOfSize(18)
    }
    
    func configTitleLabel(label: UILabel) {
        label.text = titleText
        label.textColor = titleColor
        label.font = titleFont
    }
}

protocol ExcerptPresentable {
    var excerptText: String { get }
    var excerptColor: UIColor { get }
    var excerptFont: UIFont { get }
    
    func configExcerptLabel(label: UILabel)
}

extension ExcerptPresentable {
    var excerptColor: UIColor {
        return UIColor.grayColor()
    }
    var excerptFont: UIFont {
        return UIFont.systemFontOfSize(15)
    }
    
    func configExcerptLabel(label: UILabel) {
        label.text = excerptText
        label.textColor = excerptColor
        label.font = excerptFont
    }
}

protocol TimePresentable {
    var timeText: String { get }
    var timeColor: UIColor { get }
    var timeFont: UIFont { get }
    
    func configTimeLabel(label: UILabel)
}

extension TimePresentable {
    var timeColor: UIColor {
        return UIColor.grayColor()
    }
    var timeFont: UIFont {
        return UIFont.systemFontOfSize(15)
    }
    
    func configTimeLabel(label: UILabel) {
        label.text = timeText
        label.textColor = timeColor
        label.font = timeFont
    }
}

protocol ReplyCountPresentable {
    var replyCountText: String { get }
    var replyCountColor: UIColor { get }
    var replyCountFont: UIFont { get }
    
    func configReplyCountLabel(label: UILabel)
}

extension ReplyCountPresentable {
    var replyCountColor: UIColor {
        return UIColor.grayColor()
    }
    var replyCountFont: UIFont {
        return UIFont.systemFontOfSize(15)
    }
    
    func configReplyCountLabel(label: UILabel) {
        label.text = replyCountText + "跟帖"
        label.textColor = replyCountColor
        label.font = replyCountFont
    }
}

protocol TopImageViewPresentable {
    var URL: String { get }
    
    func configTopImageView(imageView: UIImageView)
}

extension TopImageViewPresentable {
    func configTopImageView(imageView: UIImageView) {
        guard let url = NSURL(string: URL) else {
            return
        }
        imageView.sd_setImageWithURL(url)
    }
}