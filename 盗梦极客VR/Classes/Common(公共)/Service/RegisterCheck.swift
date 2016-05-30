//
//  RegisterCheck.swift
//  盗梦极客VR
//
//  Created by wl on 5/17/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


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

func checkOauthLogin(parameters: [String: String]) -> AsynOperation<User> {
    return AsynOperation { completion in 
        Alamofire.request(.GET, "http://dmgeek.com/DG_api/users/get_social_user/", parameters: parameters)
            .responseJSON { response in
                guard response.result.error == nil else {
                    dPrint("checkOauthLogin error!\n URL:\(response.result.error)")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                let value = JSON(response.result.value!)
                let user =  User(fromJson: value["user"])
                completion(.Success(user))
        }

    }
}

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
