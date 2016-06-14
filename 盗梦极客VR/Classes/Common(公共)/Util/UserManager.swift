//
//  UserManager.swift
//  盗梦极客VR
//
//  Created by wl on 5/10/16.
//  Copyright © 2016 wl. All rights reserved.
//  关于用户的操作

import Foundation
import WebKit
import SwiftyJSON

let UserDidLoginNotification = "UserDidLoginNotification"
let UserDidLoginoutNotification = "UserDidLoginoutNotification"

class UserManager: NSObject {
        /// 用户信息模型
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

    let bbsLoginStatusKey = "loginKey"
    
        /// 表示是否已经登录论坛
    var bbsIsLogin: Bool! {
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: bbsLoginStatusKey)
        }
        
        get {
            return  NSUserDefaults.standardUserDefaults().boolForKey(bbsLoginStatusKey)
        }
    }

        /// 用于用户账户同步
    var webView: WKWebView?
    
        /// 同步成功后的回调方法
    var synchronizeSuccess: ((Bool) -> ())!
        /// 同步失败后的回调方法
    var synchronizeFailure: ((ErrorType) -> ())!
        /// 用于同步
    var userID: Int!
        /// 用于存储你用户数据的key
    static let key = "UserKey"
        /// 单例方法
    static let sharedInstance = UserManager()
        /// 是否需要登录的标识
    var needAutoLoginBSS: Bool {
        return self.user != nil && !self.bbsIsLogin
    }
    
    private override init() {
        super.init()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefaults.objectForKey(UserManager.key) as? NSData {
            user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
        }else {
            user = nil
        }
    }

}

extension UserManager {
    /**
     用来更新用户数据
     在程序启动就自动调用
     */
    static func updateUserInfo(success: (() -> ())? = nil,
                               failure: (() -> ())? = nil) {
        guard let user = UserManager.sharedInstance.user else {
            return
        }
        
        checkLogin("http://dmgeek.com/DG_api/users/get_userinfo/", ["user_id": user.id])
            .complete(
                success: { user in
                    UserManager.sharedInstance.user = user
                    success?()
            }) { (_ : ErrorType) in
                failure?()
        }
    }
    
    /**
     用来将账户与论坛进行同步
     在注册完后、评论界面调用
     
     - parameter registeReturnInfo: 返回的注册信息，用于同步
     - parameter success:           成功回调
     - parameter failure:           失败的回调
     */
    func synchronizeBBSAcount(
        registeReturnInfo: RegisteReturnInfo,
        success: (Bool) -> (),
        failure: (ErrorType) -> ()) {
        let configuretion = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: CGRectZero, configuration: configuretion)
        webView.navigationDelegate = self
        
        self.webView = webView
        synchronizeSuccess = success
        synchronizeFailure = failure
        userID = registeReturnInfo.0
        let urlStr = "http://dmgeek.com/login/?action=login_bbs&cookie=\(registeReturnInfo.1)&user_id=\(registeReturnInfo.0)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = NSURL(string: urlStr)!
        let requst = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15)
        webView.loadRequest(requst)
    }
}
// MARK: - 账号信息修改方法
extension UserManager {
    func modifyNickname(nickName: String,
                        success: User -> (),
                        failure: ErrorType -> ()) {
        
        func getURLString(nonce: String) -> String {
            return "http://dmgeek.com/DG_api/users/change_nick/?user_id=\(user!.id)&nickname=\(nickName)&nonce=\(nonce)".encodeURLString()
        }
        
        getNonceValue()
            .map(getURLString)
            .then{ networkRequest($0) }
            .map { $0["status"].boolValue }
            .then(updateUserInfoAfterModify)
            .complete(success: { user in
                self.user = user
                success(user)
                }, failure: failure)
    }
    
    func modifyIcon(imageData: NSData,
                    success: ((User) -> ()),
                    failure: ((ErrorType) -> ())) {

        
        uploadImage(imageData, userID: String(user!.id))
            .map { $0["status"].boolValue }
            .then(updateUserInfoAfterModify)
            .complete(success: { user in
                    self.user = user
                    success(user)
                }, failure: failure)
    }
    
    
    func updateUserInfoAfterModify(result: Bool) -> AsynOperation<User> {
        if result {
            return checkLogin("http://dmgeek.com/DG_api/users/get_userinfo/", ["user_id": user!.id])
        }else {
            return AsynOperation { completion in
                completion(.Failure(Error.NetworkError))
            }
        }
    }
}

// MARK: - 用户登录功能
extension UserManager {
    /**
     用户普通登录方法，使用账号密码。
     在点击登录按钮、第三方第一次注册后自动调用
     
     - parameter urlStr:     登录的URL
     - parameter parameters: 参数(账号密码)
     - parameter success:    登录成功回调方法
     - parameter failure:    登录失败回调方法
     */
    static func login(parameters: [String: String],
                      success: (User) -> (),
                      failure: (ErrorType) -> ()) {
        
        checkLogin("http://dmgeek.com/DG_api/users/generate_auth_cookie/", parameters)
            .complete(
                success: { user in
                    UserManager.sharedInstance.user = user
                    UserManager.sharedInstance.bbsIsLogin = false
                    NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginNotification, object: nil)
                    success(user)
                    
                    //友盟账号统计
                    MobClick.profileSignInWithPUID(user.username)
                },
                failure: failure
        )
    }
    /**
     第三方登录调用方法
     在第三方登录授权后调用
     - parameter user: 第三方授权后获得的用户信息
     */
    static func login(user: User) {
        UserManager.sharedInstance.user = user
        NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginNotification, object: nil)
        //友盟账号统计
        MobClick.profileSignInWithPUID(user.username)
    }
    
    /**
     退出登录调用方法，退出登录
     在点击退出登录后调用
     */
    static func loginout() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey(UserManager.key)
        userDefaults.synchronize()
        
        UserManager.sharedInstance.user = nil
        UserManager.sharedInstance.bbsIsLogin = false
        NSNotificationCenter.defaultCenter().postNotificationName(UserDidLoginoutNotification, object: nil)
        
        //友盟账号统计
        MobClick.profileSignOff()
    }
    /**
     第三方登录方法，
     在第三方授权后调用
     - parameter usid:         第三方授权返回的id
     - parameter platformName: 授权平台
     - parameter success:      登录成功的回调
     - parameter failure:      登录失败的回调
     */
    static func oauthLogin(usid: String,
                           platformName: String,
                           success: (User) -> (),
                           failure: (ErrorType) -> ()) {
        let parameters: [String: String] = [
            "s_id": usid,
            "s_type": platformName
        ]
        
        checkOauthLogin("http://dmgeek.com/DG_api/users/get_social_user/", parameters: parameters)
            .complete(success: success,
                      failure: failure)
        
    }

}

// MARK: - 注册方法
extension UserManager {
    /**
     检验邮箱唯一性
     在用户输入完邮箱后调用
     
     - parameter email:   需要检验的邮件地址
     - parameter success: 成功的回调方法
     - parameter failure: 失败的回调方法
     */
    static func checkEmailValid(email: String,
                                success: (Bool) -> (),
                                failure: (ErrorType) -> ()) {
        
        checkInfoValid("http://dmgeek.com/DG_api/users/email_exists/",
            parameters: ["email": email])
            .complete(success: success, failure: failure)
    }
    
    /**
     检验账号唯一性
     在用户输入完账号后调用
     
     - parameter account: 需要检验的账号
     - parameter success: 成功的回调方法
     - parameter failure: 失败的回调方法
     */
    static func checkAccountValid(account: String,
                                  success: (Bool) -> (),
                                  failure: (ErrorType) -> ()) {
        
        checkInfoValid("http://dmgeek.com/DG_api/users/user_id_exists/",
            parameters: ["user_id": account])
            .complete(success: success, failure: failure)
    }
    
    /**
     注册方法
     在用户点击注册后调用
     
     - parameter registerInfo: 一些注册必要信息
     - parameter success:      成功的回调函数
     - parameter failure:      失败的回调函数
     */
    static func register(registerInfo:
        (   nickName: String,
            email: String,
            account: String,
            password: String?,
            oauthInfo: OauthInfo?
        ),
                         success: (Int, String) -> (),
                         failure: (ErrorType) -> ()) {
        
        func jointParameters(nonce: String) -> [String: String] {
            
            var parameters =  [
                "username": registerInfo.account,
                "email": registerInfo.email,
                "nickname": registerInfo.nickName,
                "nonce": nonce,
                "notify": "both",
                "display_name": registerInfo.nickName,
                "s_id": registerInfo.oauthInfo?.usid ?? "",
                "s_type": registerInfo.oauthInfo?.platformName ?? "",
                "s_token": registerInfo.oauthInfo?.token ?? "",
                "avatar": registerInfo.oauthInfo?.iconURL ?? ""
            ]

            if let password = registerInfo.password {
                parameters["user_pass"] = password
            }
            
            return parameters
        }
        
        getNonceValue()
            .map(jointParameters)
            .then(checkRegisterValid)
            .complete(
                success: success,
                failure: failure)
    }
}

// MARK: - WKNavigationDelegate
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
