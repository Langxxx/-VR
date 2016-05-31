//
//  LoginController.swift
//  盗梦极客VR
//
//  Created by wl on 5/5/16.
//  Copyright © 2016 wl. All rights reserved.
//  登录控制器

import UIKit
import MBProgressHUD

class LoginController: UIViewController {

    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    var parameters: [String: String] {
        return [
            "username": accountTextField.text!,
            "password": passwordTextField.text!
        ]
    }
    
//    var completion: ((user: User) -> Void)?
        /// 授权返回的信息
    var oauthInfo: (
        platformName: String,
        usid: String,
        username: String,
        iconURL: String)? {
        didSet {
            doSomeForOauthLogin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        dPrint("LoginController deinit")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
}

// MARK: - 功能方法
extension LoginController {
    
    /**
     进行登录请求
     当用户点击登录后调用(第三方授权注册后自动调用)
     
     - parameter parameters: 登录参数
     */
    func login(parameters: [String: String]) {
        func success(user: User) {
            MBProgressHUD.hideHUD()
            navigationController?.popViewControllerAnimated(true)
        }
        
        func failure(error: ErrorType) {
            switch error as! Error {
            case .AccountInvalid:
                MBProgressHUD.showError("账号/密码错误")
            case .NetworkError:
                MBProgressHUD.showError("网络拥堵，请稍后尝试")
            default:
                break
            }
        }
        
        MBProgressHUD.showMessage("正在登陆...")
        
        UserManager.login(parameters,
                          success: success,
                          failure: failure)
    }
    
    /**
     做一些第三方登录成功后的操作，主要是自动登录或者跳转注册
     第三方授权成功后调用
     */
    func doSomeForOauthLogin() {
        guard let oauthInfo = oauthInfo else {
            return
        }
        
        func success(user: User) {
            MBProgressHUD.hideHUD()
            // 第一次进行第三方登陆，需要进行注册
            if user.id == 0 {
                let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("RegisterController") as! RegisterController
                vc.oauthInfo = oauthInfo
                vc.autoLogin = login
                navigationController?.pushViewController(vc, animated: true)
            }else {
                UserManager.login(user)
                navigationController?.popViewControllerAnimated(true)
            }
        }
        
        func failure(_: ErrorType) {
            MBProgressHUD.showError("网络繁忙，请稍后测试")
        }
        MBProgressHUD.showMessage("正在获取用户信息...")
        UserManager.oauthLogin(oauthInfo.usid,
                               platformName: oauthInfo.platformName,
                               success: success,
                               failure: failure)
    }
    
    /**
     获取第三方授权登录返回的信息
     第三方授权成功后调用
     
     - parameter snsAccount: 授权信息
     */
    func fillOauthInfo(snsAccount: AnyObject) {
        let usid = snsAccount.usid
        let userName = snsAccount.userName
        let iconURL = snsAccount.iconURL
        let platformName = snsAccount.platformName
        self.oauthInfo = (platformName, usid, userName, iconURL)
    }
}

// MARK: - 监听方法
extension LoginController {
    
    @IBAction func registerButtonClik() {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("RegisterController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonClik() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func loginButtonClik() {
        guard let account = accountTextField.text where !account.isEmpty else {
            MBProgressHUD.showError("账号不能为空!")
            return
        }
        guard let password = passwordTextField.text where !password.isEmpty else {
            MBProgressHUD.showError("密码不能为空!")
            return
        }
        
        login(parameters)
    }
    
    
    @IBAction func QQLoginButtonClik() {
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToQQ)
        snsPlatform.loginClickHandler!(self, UMSocialControllerService.defaultControllerService(), true) { response in
            
            if response.responseCode == UMSResponseCodeSuccess {
                let snsAccount = UMSocialAccountManager.socialAccountDictionary()[UMShareToQQ]!
                self.fillOauthInfo(snsAccount)
            }
        }
    }
    
    @IBAction func SinaLoginButtonClik() {
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToSina)
    
        snsPlatform.loginClickHandler!(self, UMSocialControllerService.defaultControllerService(), true) { response in
            
            if response.responseCode == UMSResponseCodeSuccess {
                let snsAccount = UMSocialAccountManager.socialAccountDictionary()[UMShareToSina]!
                self.fillOauthInfo(snsAccount)
            }
        }
    }
    // TODO: 应用未审核，第三方登陆无效
    @IBAction func WechatLoginButtonClik() {
        MBProgressHUD.showWarning("暂不支持!")
//        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
//        snsPlatform.loginClickHandler!(self, UMSocialControllerService.defaultControllerService(), true) { response in
//            
//            if response.responseCode == UMSResponseCodeSuccess {
//                let snsAccount = UMSocialAccountManager.socialAccountDictionary()[UMShareToWechatSession]
//                dPrint("userName: \(snsAccount)")
//            }
//        }
    }
    
}
