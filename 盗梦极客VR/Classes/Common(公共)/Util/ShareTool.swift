//
//  UMSDK+Extension.swift
//  盗梦极客VR
//
//  Created by wl on 4/30/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

struct ShareTool {
    
    static var shareArray: [String] {
        return [UMShareToSina, UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToEmail,UMShareToSms]
    }
    
    static var shareImage: UIImage {
        return UIImage(named: "dmgeek_100")!
    }
    
    static func setAllAppKey() {
        UMSocialData.setAppKey("5722b62d67e58ec79c002539")
        UMSocialSinaSSOHandler.openNewSinaSSOWithAppKey("2213009825", secret: "5128b0e807dc390492346e67bc9c1a92", redirectURL: "http://dmgeek.com/")
        UMSocialQQHandler.setQQWithAppId("101247950", appKey: "67904d0b171250c196b4518b33d7ecb6", url: "http://dmgeek.com/")
        UMSocialWechatHandler.setWXAppId("wxf2715ae6f80411f7", appSecret: "45e56c520a70873f0e71f128f8048f9a", url: "http://dmgeek.com/")
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline])
    }
    
    static func setAllShareConfig(newsModel: NewsModel) {
        UMSocialData.defaultData().extConfig.qqData.title = newsModel.title
        UMSocialData.defaultData().extConfig.qqData.url = newsModel.url
        UMSocialData.defaultData().extConfig.qqData.shareText = newsModel.excerpt
        UMSocialData.defaultData().extConfig.qzoneData.title = newsModel.title
        UMSocialData.defaultData().extConfig.qzoneData.url = newsModel.url
        UMSocialData.defaultData().extConfig.qzoneData.shareText = newsModel.excerpt
        UMSocialData.defaultData().extConfig.sinaData.shareText = "VR资讯: 《" + newsModel.title + "》" + newsModel.url + " (分享自@盗梦极客_虚拟现实专题网)"
        
        UMSocialData.defaultData().extConfig.wechatSessionData.url = newsModel.url
        UMSocialData.defaultData().extConfig.wechatSessionData.title = newsModel.title
        UMSocialData.defaultData().extConfig.wechatSessionData.shareText = newsModel.excerpt
        
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = newsModel.url
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = newsModel.title
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = newsModel.excerpt
        
        UMSocialData.defaultData().extConfig.emailData.title = newsModel.title
        UMSocialData.defaultData().extConfig.emailData.shareText = newsModel.excerpt
        
        UMSocialData.defaultData().extConfig.smsData.shareText = newsModel.title
    }
    
}