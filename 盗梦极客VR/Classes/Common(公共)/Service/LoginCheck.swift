//
//  LoginCheck.swift
//  盗梦极客VR
//
//  Created by wl on 5/6/16.
//  Copyright © 2016 wl. All rights reserved.
//  登陆逻辑的验证

import Foundation
import SwiftyJSON
import Alamofire

extension User: JSONToModel {
    
}

/**
 用于进行登陆验证，
 在用户登陆、启动APP进行用户数据更新的时候调用。(由UserManager调用)
 
 - parameter url:        登陆URL
 - parameter parameters: 参数
 
 - returns: 用户数据模型
 */
func checkLogin(url: String, _ parameters: [String: AnyObject] = [:]) -> AsynOperation<User> {
    return loginRequest(url, parameters)
        .then(checkValidity)
    
}

/**
 登陆第一步，发出登陆请求，
 checkLogin调用
 
 - parameter url:        登陆URL
 - parameter parameters: 参数
 
 - returns: 登陆后反馈的JSON
 */
func loginRequest(url: String, _ parameters: [String: AnyObject] = [:]) -> AsynOperation<JSON> {
    return networkRequest(url, parameters: parameters)
}

/**
 登陆第二步，检验登陆正确性，
 在loginRequest完成之后调用
 
 - parameter json: 登陆请求返回的URL
 
 - returns: 用户数据或者Error.AccountInvalid
 */
func checkValidity(json: JSON) -> AsynOperation<User> {
    guard json["status"].stringValue == "ok" else {
        return AsynOperation { completion in
            completion(.Failure(Error.AccountInvalid))
        }
    }
    return AsynOperation { completion in
        let user = User(fromJson: json["user"])
        completion(.Success(user))
    }
}

/**
 进行第三方登陆
 在授权成功后调用(UserManager调用)
 - parameter parameters: 参数
 
 - returns: 成功用户信息(第一次登陆为空)；失败NetworkError
 */
func checkOauthLogin(url: String, parameters: [String: String]) -> AsynOperation<User> {
    return networkRequest(url, parameters: parameters)
        .map { User(fromJson: $0["user"]) }
}
