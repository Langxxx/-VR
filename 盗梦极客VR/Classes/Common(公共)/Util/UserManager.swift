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

    var user: User? {
        didSet {
            if user != nil {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let data = NSKeyedArchiver.archivedDataWithRootObject(user!)
                userDefaults.setObject(data, forKey: UserManager.key)
                userDefaults.synchronize()
            }
        }
    }
    
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
                      parameters: [String: AnyObject],
                      success: (User) -> (),
                      failure: (ErrorType) -> ()) {
        
        checkLogin(urlStr, parameters)
            .complete(
                success: { user in
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
        
        checkInfoValid("http://dmgeek.com/DG_api/users/user_id_exists/",
            parameters: ["user_id": account])
            .complete(success: success, failure: failure)
    }
    
    static func register(registerInfo:
                                    (   nickName: String,
                                        email: String,
                                        account: String,
                                        password: String,
                                        usid: String?,
                                        platformName: String?
                                    ),
                         success: (Bool) -> (),
                         failure: (ErrorType) -> ()) {
        
        func jointParameters(nonce: String) -> [String: String] {
            return [
                "username": registerInfo.account,
                "email": registerInfo.email,
                "nickname": registerInfo.nickName,
                "user_pass": registerInfo.password,
                "nonce": nonce,
                "notify": "both",
                "display_name": registerInfo.nickName,
                "s_id": registerInfo.usid ?? "",
                "s_type": registerInfo.platformName ?? ""
            ]
        }

        getNonceValue()
            .map(jointParameters)
            .then(checkRegisterValid)
            .complete(success: success, failure: failure)
    }
    
    static func oauthLogin(usid: String,
                           platformName: String,
                           success: (User) -> (),
                           failure: (ErrorType) -> ()) {
        let parameters: [String: String] = [
            "s_id": usid,
            "s_type": platformName
        ]

        checkOauthLogin(parameters)
                .complete(success: success,
                          failure: failure)

    }
    
    static func login(user: User) {
        UserManager.sharedInstance.user = user
        NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginNotification, object: nil)
    }
    
    static func updateUserInfo() {
        guard let user = UserManager.sharedInstance.user else {
            return
        }
        
        checkLogin("http://dmgeek.com/DG_api/users/get_userinfo/", ["user_id": user.id])
            .complete(
                success: { user in
                    UserManager.sharedInstance.user = user
            }) { (_ : ErrorType) in
                
            }
    }
}