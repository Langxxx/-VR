//
//  DeviceCellViewModel.swift
//  盗梦极客VR
//
//  Created by wl on 5/15/16.
//  Copyright © 2016 wl. All rights reserved.
//   DeviceCell的Viewmodel，负责 DeviceCell显示逻辑

import Foundation

typealias DeviceCellPresentable = protocol<TitlePresentable, TopImageViewPresentable, TimePresentable, TagPresentable>

struct DeviceCellViewModel: DeviceCellPresentable {
    var titleText: String
    var timeText: String
    var URL: String
    var tagString: String
    
    init(model: NewsModel) {
        URL = model.listThuUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        titleText = model.title
        timeText = model.date.componentsSeparatedByString(" ").first!
        tagString = model.tag
    }
    
    func configTopImageView(imageView: UIImageView) {
        guard let url = NSURL(string: URL) else {
            return
        }
        imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholderImage_1_1"))
    }
}