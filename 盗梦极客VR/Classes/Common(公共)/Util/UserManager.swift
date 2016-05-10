//
//  UserManager.swift
//  盗梦极客VR
//
//  Created by wl on 5/10/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

class UserManager {

    let user: User?
    
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
                success(user)
                },
                failure: failure
            )
    }
    
    static func loginout() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(UserManager.key)
    }
}