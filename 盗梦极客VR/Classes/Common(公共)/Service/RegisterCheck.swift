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
                    print("loginRequest error!\n URL:\(response.result.error)")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                let value = JSON(response.result.value!)
                completion(.Success(value["status"].boolValue))
            }
    }
}
