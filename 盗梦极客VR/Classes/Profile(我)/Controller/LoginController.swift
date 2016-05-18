//
//  LoginController.swift
//  盗梦极客VR
//
//  Created by wl on 5/5/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginController: UIViewController {

    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let loginUrl = "http://dmgeek.com/DG_api/users/generate_auth_cookie/"
    var parameters: [String: String] {
        return [
            "username": accountTextField.text!,
            "password": passwordTextField.text!
        ]
    }
    
//    var completion: ((user: User) -> Void)?
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
        print("LoginController deinit")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
}

extension LoginController {
    
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
        
        UserManager.login(loginUrl,
                          parameters: parameters,
                          success: success,
                          failure: failure)
    }
    
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
}

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
    
    // TODO: 应用未审核，第三方登陆无效
    @IBAction func QQLoginButtonClik() {
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToQQ)
        snsPlatform.loginClickHandler!(self, UMSocialControllerService.defaultControllerService(), true) { response in
            
            if response.responseCode == UMSResponseCodeSuccess {
                let snsAccount = UMSocialAccountManager.socialAccountDictionary()[UMShareToQQ]
                print("userName: \(snsAccount)")
            }
        }
    }
    
    @IBAction func SinaLoginButtonClik() {
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToSina)
    
        snsPlatform.loginClickHandler!(self, UMSocialControllerService.defaultControllerService(), true) { response in
            
            if response.responseCode == UMSResponseCodeSuccess {
                let snsAccount = UMSocialAccountManager.socialAccountDictionary()[UMShareToSina]!
                let usid = snsAccount.usid
                let userName = snsAccount.userName
                let iconURL = snsAccount.iconURL
                let platformName = snsAccount.platformName
                self.oauthInfo = (platformName, usid, userName, iconURL)
                print("userName: \(snsAccount)")
            }
        }
    }
    
    @IBAction func WechatLoginButtonClik() {
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
        snsPlatform.loginClickHandler!(self, UMSocialControllerService.defaultControllerService(), true) { response in
            
            if response.responseCode == UMSResponseCodeSuccess {
                let snsAccount = UMSocialAccountManager.socialAccountDictionary()[UMShareToWechatSession]
                print("userName: \(snsAccount)")
            }
        }
    }
    
}
