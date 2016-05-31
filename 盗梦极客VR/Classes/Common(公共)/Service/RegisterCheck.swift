//
//  RegisterCheck.swift
//  盗梦极客VR
//
//  Created by wl on 5/17/16.
//  Copyright © 2016 wl. All rights reserved.
//  注册相关逻辑

import Foundation
import Alamofire
import SwiftyJSON

/**
 用于注册前检测注册信息的正确性(目前主要是检测邮箱和账号唯一性)
 在用户输入完邮箱或者账号后调用(UserManager调用)
 
 - parameter str:        验证URL
 - parameter parameters: 参数
 
 */
func checkInfoValid(str: String, parameters: [String: AnyObject]) -> AsynOperation<Bool> {
    
    return AsynOperation { completion in
        Alamofire.request(.GET, str, parameters: parameters)
            .responseJSON { response in
                guard response.result.error == nil else {
                    dPrint("checkInfoValid error!\n URL:\(response.result.error)")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                let value = JSON(response.result.value!)
                completion(.Success(value["status"].boolValue))
            }
    }
}

/**
 注册操作第一步，取得Nonce的值。
 点击注册后调用(由UserManager嗲用)
 
 - parameter urlStr:     URL一般使用默认值
 - parameter parameters: 参数一般也是默认值
 
 - returns: Nonce值或者NetworkError
 */
func getNonceValue(urlStr: String = "http://dmgeek.com/DG_api/get_nonce/",
                   parameters: [String: AnyObject] = [
    "controller": "users",
    "method": "register"
    ]) -> AsynOperation<String> {
    
    return AsynOperation { completion in
        Alamofire.request(.GET, urlStr, parameters: parameters)
            .responseJSON { response in
                guard response.result.error == nil else {
                    dPrint("loginRequest error!\n URL:\(response.result.error)")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                let value = JSON(response.result.value!)
                if value["status"].stringValue != "ok" {
                    completion(.Failure(Error.NetworkError))
                }else {
                    completion(.Success(value["nonce"].stringValue))
                }
        }
    }
}

typealias UserID = Int
typealias Cookie = String
typealias RegisteReturnInfo = (UserID, Cookie)

/**
 注册第二步，检查注册合法性
 在getNonceValue之后调用
 
 - parameter parameters: 参数
 
 - returns: 成功：注册返回的参数(cookie、userID)；失败返回错误原因或者NetworkError
 */
func checkRegisterValid(parameters: [String: String])
    -> AsynOperation<RegisteReturnInfo> {
    
    return AsynOperation { completion in
        Alamofire.request(.GET, "http://dmgeek.com/DG_api/users/register/", parameters: parameters)
            .responseJSON { response in
                guard response.result.error == nil else {
                    dPrint("loginRequest error!\n URL:\(response.result.error)")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                let value = JSON(response.result.value!)
                if value["status"].stringValue == "error" {
                    completion(.Failure(Error.RegisterError(value["error"].stringValue)))
                }else {
                    let userID = value["user_id"].intValue
                    let cookie = value["cookie"].stringValue
                    let info = (userID, cookie)
                     completion(.Success(info))
                }
        }
    }
}

/**
 设账号置为同步状态
 在账号与论坛同步成功后调用(UserManager调用)
 - parameter urlStr: 同步请求URL
 */
func synchronizeAcount(urlStr: String) -> AsynOperation<Bool>  {
    return AsynOperation { completion in
        Alamofire.request(.GET, urlStr)
            .responseJSON { response in
                guard response.result.error == nil else {
                    dPrint("synchronizeAcount error!\n URL:\(response.result.error)")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                let value = JSON(response.result.value!)
                let status = value["status"].stringValue
                if status == "ok" {
                    completion(.Success(true))
                }else {
                    completion(.Success(false))
                }
        }
        
    }
}
