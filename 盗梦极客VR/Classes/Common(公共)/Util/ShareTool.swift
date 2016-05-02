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
    
    static func setAllShareConfig(title: String = "", shareText: String = "", url: String = "") {
        UMSocialData.defaultData().extConfig.qqData.title = title
        UMSocialData.defaultData().extConfig.qqData.url = url
        UMSocialData.defaultData().extConfig.qqData.shareText = shareText
        UMSocialData.defaultData().extConfig.qzoneData.title = title
        UMSocialData.defaultData().extConfig.qzoneData.url = url
        UMSocialData.defaultData().extConfig.qzoneData.shareText = shareText
        UMSocialData.defaultData().extConfig.sinaData.shareText = "VR资讯: 《" + title + "》" + url + " (分享自@盗梦极客_虚拟现实专题网)"
        
        UMSocialData.defaultData().extConfig.wechatSessionData.url = url
        UMSocialData.defaultData().extConfig.wechatSessionData.title = title
        UMSocialData.defaultData().extConfig.wechatSessionData.shareText = shareText
        
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = url
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = title
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = shareText
        
        UMSocialData.defaultData().extConfig.emailData.title = title
        UMSocialData.defaultData().extConfig.emailData.shareText = shareText
        
        UMSocialData.defaultData().extConfig.smsData.shareText = title
    }
    
}