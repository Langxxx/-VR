//
//  UserManager.swift
//  盗梦极客VR
//
//  Created by wl on 5/10/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation
import WebKit

let UserDidLoginNotification = "UserDidLoginNotification"
let UserDidLoginoutNotification = "UserDidLoginoutNotification"

class UserManager: NSObject {

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
    
    let passwordKey = "passwordKey"
    let accountKey = "accountKey"
    let bbsLoginStatusKey = "loginKey"
    var password: String! {
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue!, forKey: passwordKey)
        }
        
        get {
            return  NSUserDefaults.standardUserDefaults().objectForKey(passwordKey) as! String
        }
    }
    
    var account: String! {
        set {
             NSUserDefaults.standardUserDefaults().setObject(newValue!, forKey: accountKey)
        }
        
        get {
            return  NSUserDefaults.standardUserDefaults().objectForKey(accountKey) as! String
        }
    }
    
    var bbsIsLogin: Bool! {
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: bbsLoginStatusKey)
        }
        
        get {
            return  NSUserDefaults.standardUserDefaults().boolForKey(bbsLoginStatusKey)
        }
    }

    var webView: WKWebView?
    
    var synchronizeSuccess: ((Bool) -> ())!
    var synchronizeFailure: ((ErrorType) -> ())!
    var userID: Int!
    
    static let key = "UserKey"
    
    static let sharedInstance = UserManager()
    private override init() {
        super.init()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefaults.objectForKey(UserManager.key) as? NSData {
            user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
        }else {
            user = nil
        }
    }
    
    static func login(urlStr: String,
                      parameters: [String: String],
                      success: (User) -> (),
                      failure: (ErrorType) -> ()) {
        
        checkLogin(urlStr, parameters)
            .complete(
                success: { user in
                UserManager.sharedInstance.user = user
                UserManager.sharedInstance.password = parameters["password"]
                UserManager.sharedInstance.account = parameters["username"]
                UserManager.sharedInstance.bbsIsLogin = false
                NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginNotification, object: nil)
                success(user)
                },
                failure: failure
            )
    }
    
    static func login(user: User) {
        UserManager.sharedInstance.user = user
        NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginNotification, object: nil)
    }
    
    static func loginout() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(UserManager.key)
        userDefaults.synchronize()
        UserManager.sharedInstance.user = nil
         UserManager.sharedInstance.bbsIsLogin = false
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
                         success: (Int) -> (),
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
            .complete(
                success: { userID in
                    UserManager.sharedInstance.password = registerInfo.password
                    UserManager.sharedInstance.account = registerInfo.account
                    success(userID)
                }, failure: failure)
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

    
    func synchronizeBBSAcount(
        userID: Int,
        success: (Bool) -> (),
        failure: (ErrorType) -> ()) {
        let configuretion = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: CGRectZero, configuration: configuretion)
        webView.navigationDelegate = self
        
        self.webView = webView
        self.userID = userID
        synchronizeSuccess = success
        synchronizeFailure = failure
        
        let url = NSURL(string: "http://dmgeek.com/login/?action=login_bbs&username=\(account)&password=\(password)")!
        let requst = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15)
        webView.loadRequest(requst)
    }

}

extension UserManager {
    var needAutoLoginBSS: Bool {
        return self.user != nil && !self.bbsIsLogin
    }
}

extension UserManager: WKNavigationDelegate {
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        dPrint("正在加载...")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        dPrint("加载成功...")
        synchronizeAcount("http://dmgeek.com/DG_api/users/set_bbs_user_created/?user_id=\(userID)")
            .complete(success: synchronizeSuccess,
                      failure: synchronizeFailure)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        synchronizeFailure(Error.NetworkError)
    }
}
