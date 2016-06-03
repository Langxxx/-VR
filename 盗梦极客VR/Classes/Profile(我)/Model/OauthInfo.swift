//
//  RegiterInfo.swift
//  盗梦极客VR
//
//  Created by wl on 6/3/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

struct OauthInfo {
    let platformName: String
    let usid: String
    let username: String
    let iconURL: String
    let token: String
    
    init(snsAccount: AnyObject) {
        usid = snsAccount.usid
        username = snsAccount.userName
        iconURL = snsAccount.iconURL
        platformName = snsAccount.platformName
        token = snsAccount.accessToken
    }
}