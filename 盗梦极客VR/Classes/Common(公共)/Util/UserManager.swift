//
//  UserManager.swift
//  盗梦极客VR
//
//  Created by wl on 5/10/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

let UserDidLoginNotification = "UserDidLoginNotification"
let UserDidLoginoutNotification = "UserDidLoginoutNotification"

class UserManager {

    var user: User?
    
    static let key = "UserKey"
    
    static let sharedInstance = UserManager()
    private init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefaults.objectForKey(UserManager.key) as? NSData {
            user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
        }else {
            user = nil
        }
    }
    
    static func login(urlStr: String,
                      paramaters: [String: AnyObject],
                      success: (User) -> (),
                      failure: (ErrorType) -> ()) {
        
        checkLogin(urlStr, paramaters)
            .complete(
                success: { user in
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let data = NSKeyedArchiver.archivedDataWithRootObject(user)
                userDefaults.setObject(data, forKey: UserManager.key)
                userDefaults.synchronize()
                UserManager.sharedInstance.user = user
                NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginNotification, object: nil)
                success(user)
                },
                failure: failure
            )
    }
    
    static func loginout() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(UserManager.key)
        userDefaults.synchronize()
        UserManager.sharedInstance.user = nil
        NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginoutNotification, object: nil)
    }
    
    static func checkEmailValid(email: String,
                                success: (Bool) -> (),
                                failure: (ErrorType) -> ()) {
        
        checkInfoValid("http://dmgeek.com/DG_api/users/email_exists/",
                       parameters: ["email": email])
            .complete(success: success, failure: failure)
    }
    
    static func checkAccountValid(account: String,
                                success: (Bool) -> (),
                                failure: (ErrorType) -> ()) {
        
        checkInfoValid("http://dmgeek.com/DG_api/users/email_exists/",
            parameters: ["user_id": account])
            .complete(success: success, failure: failure)
    }
    
//    static func register(registerInfo:
//                                    (   nickName: String,
//                                        email: String,
//                                        account: String,
//                                        password: String
//                                    ),
//                         success: () -> (),
//                         failure: () -> ()) {
//        
//        func jointParameters(nonce: String) -> [String: AnyObject] {
//            return [
//                "username": registerInfo.account,
//                "email": registerInfo.email,
//                "nickname": registerInfo.nickName,
//                "user_pass": registerInfo.password,
//                "nonce": nonce,
//                "notify": "both",
//                "display_name": registerInfo.nickName
//            ]
//        }
//        
//        getNonceValue()
//            .map(jointParameters)
//            .then(checkRegisterValid)
//    }
}