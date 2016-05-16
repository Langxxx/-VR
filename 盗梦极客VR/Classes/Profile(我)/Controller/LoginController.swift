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
            }
        }
        
        MBProgressHUD.showMessage("正在登陆...")
        
        UserManager.login(loginUrl,
                          paramaters: parameters,
                          success: success,
                          failure: failure)
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
                let snsAccount = UMSocialAccountManager.socialAccountDictionary()[UMShareToSina]
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
