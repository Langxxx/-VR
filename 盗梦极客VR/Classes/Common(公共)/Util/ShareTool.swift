//
//  UMSDK+Extension.swift
//  盗梦极客VR
//
//  Created by wl on 4/30/16.
//  Copyright © 2016 wl. All rights reserved.
//  友盟的一些分享设置

import Foundation
import MBProgressHUD

let CopyPlatform = "copyPlatform"
let SafariPlatform = "safariPlatform"
struct ShareTool {
    
    static var customLink: String = ""
        /// 期待分享的平台
    static var shareArray: [String] {
        return [UMShareToSina, UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToEmail, SafariPlatform,  CopyPlatform]
    }
        /// 分享的默认图标
    static var shareImage: UIImage {
        return UIImage(named: "dmgeek_100")!
    }
    /**
     设置所有平台的APPKEY
     在程序启动就调用
     */
    static func setAllAppKey() {
        UMSocialData.setAppKey("5722b62d67e58ec79c002539")
        UMSocialSinaSSOHandler.openNewSinaSSOWithAppKey("2213009825", secret: "5128b0e807dc390492346e67bc9c1a92", redirectURL: "http://dmgeek.com/")
        UMSocialQQHandler.setQQWithAppId("1105296287", appKey: "GJtsNkQpSGYh3k2m", url: "http://dmgeek.com/")
        UMSocialWechatHandler.setWXAppId("wxf2715ae6f80411f7", appSecret: "45e56c520a70873f0e71f128f8048f9a", url: "http://dmgeek.com/")
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline])
    }
    
    /**
     设置所有分享的默认参数
     分享前进行调用
     - parameter title:     分享标题
     - parameter shareText: 分享描述文章
     - parameter url:       跳转URL
     */
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
        
        ShareTool.customLink = url
    }
    
}

extension AppDelegate {
    func addCustomSharelatform() {
        let copyPlatform = UMSocialSnsPlatform(platformName: CopyPlatform)
        copyPlatform.displayName = "复制链接"
        copyPlatform.bigImageName = "link"
        copyPlatform.snsClickHandler = { [weak self] (presentingController, socialControllerService, isPresentInController) in
            let pastboad = UIPasteboard.generalPasteboard()
            pastboad.string = ShareTool.customLink
            let tab = self?.window?.rootViewController as! TabBarController
            let nav = tab.selectedViewController as! NavigationController
            nav.showHint()

        }
        
        let safariPlatform = UMSocialSnsPlatform(platformName: SafariPlatform)
        safariPlatform.displayName = "用Safari打开"
        safariPlatform.bigImageName = "safari"
        safariPlatform.snsClickHandler = { (presentingController, socialControllerService, isPresentInController) in
            UIApplication.sharedApplication().openURL(NSURL(string: ShareTool.customLink.encodeURLString())!)
        }
        
        UMSocialConfig.addSocialSnsPlatform([copyPlatform, safariPlatform])
        UMSocialConfig.setSnsPlatformNames(ShareTool.shareArray)
    }
}

extension UINavigationController {
    func showHint() {
        MBProgressHUD.showSuccess("复制链接成功!")
    }
}