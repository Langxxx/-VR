//
//  AppDelegate.swift
//  盗梦极客VR
//
//  Created by wl on 4/20/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        UMSocialData.openLog(true)
        IQKeyboardManager.sharedManager().enable = false
        
        ShareTool.setAllAppKey()
        UserManager.updateUserInfo()
        addCustomSharelatform()
        
        
        let userAgent = UIWebView().stringByEvaluatingJavaScriptFromString("navigator.userAgent")! + " DG_iosapp"
        NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent" : userAgent])
        
        // 友盟统计
        
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        MobClick.setAppVersion(currentVersion)
        UMAnalyticsConfig.sharedInstance().appKey = "5722b62d67e58ec79c002539"
        UMAnalyticsConfig.sharedInstance().channelId = "App Store"

        MobClick.startWithConfigure(UMAnalyticsConfig.sharedInstance())
        // 不开启后台
        MobClick.setBackgroundTaskEnabled(false)
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
}

