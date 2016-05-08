//
//  LoginCheck.swift
//  盗梦极客VR
//
//  Created by wl on 5/6/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension User: JSONToModel {
    
}

func checkLogin(url: String, _ parameters: [String: AnyObject] = [:]) -> AsynOperation<User> {
    return loginRequest(url, parameters)
        .then(checkValidity)
    
}

func loginRequest(url: String, _ parameters: [String: AnyObject] = [:]) -> AsynOperation<JSON> {
    return AsynOperation { completion in
        Alamofire.request(.GET, "http://dmgeek.com/DG_api/users/generate_auth_cookie/",parameters: parameters)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print("loginRequest error!\n URL:\(response.result.error)")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                let value = JSON(response.result.value!)
                completion(.Success(value))
        }
    }
}

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