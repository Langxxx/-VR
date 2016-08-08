//
//  BBSURLConfig.swift
//  盗梦极客VR
//
//  Created by wl on 4/23/16.
//  Copyright © 2016 wl. All rights reserved.
//  一些webView期待加载的URL，除了这些，其他的全部跳转给Safari处理

import AVKit

extension BBSController {
        /// 一些webView期待加载的URL，除了这些，其他的全部跳转给Safari处理
    var expectedURLS: [String] {
        return [
        "http://bbs.dmgeek.com/",
        //登录重定向链接
        "http://dmgeek.com/discourse/",
        "http://m.dmgeek.com/",
        "http://dmgeek.com/login/",
//        //使用QQ登录链接
//        "https://graph.qq.com/oauth2.0/",
//        "https://xui.ptlogin2.qq.com/cgi-bin/",
//        "https://openmobile.qq.com/oauth2.0/",
//        //微博
//        "https://api.weibo.com/oauth2/",
//        //百度
//        "https://openapi.baidu.com/oauth/"
        ]
    }
    /**
     判断一个url是否是我们想用webView加载的
     
     - parameter urlString: 需要进行判断的URL
     
     - returns: 是否
     */
    func isExpectedURL(urlString: String) -> Bool {
        for expectedURL in expectedURLS {
            if urlString.hasPrefix(expectedURL) {
                return true
            }
        }
        return false
    }
}

