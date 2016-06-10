//
//  RegisterController.swift
//  盗梦极客VR
//
//  Created by wl on 5/16/16.
//  Copyright © 2016 wl. All rights reserved.
//  注册

import UIKit
import IQKeyboardManager
import MBProgressHUD
import WebKit

class RegisterController: UIViewController {
    
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var againPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    @IBOutlet weak var nicknameErrorInfo: UILabel!
    @IBOutlet weak var emailErrorInfo: UILabel!
    @IBOutlet weak var accountErrorInfo: UILabel!
    @IBOutlet weak var passwordErrorInfo: UILabel!
    @IBOutlet weak var againPasswordErrorInfo: UILabel!
    
    @IBOutlet weak var nicknameValidLogo: UIButton!
    @IBOutlet weak var emailValidLogo: UIButton!
    @IBOutlet weak var accountValidLogo: UIButton!
    @IBOutlet weak var passwordValidLogo: UIButton!
    @IBOutlet weak var againPasswordValidLogo: UIButton!
    
    @IBOutlet weak var emailActivityView: UIActivityIndicatorView!
    @IBOutlet weak var accountActivityView: UIActivityIndicatorView!
    
    @IBOutlet weak var oauthInfoLabel: UILabel!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler!
    
        /// 注册信息合法性校验位
    var validCount: UInt8 = 0b00000000 {
        didSet {
            if validCount == 0b00011111 {
                registerButton.enabled = true
            }else {
                registerButton.enabled = false
            }
        }
    }
    
        /// 第三方授权信息，如果是第三跳转来的注册界面才有值
    var oauthInfo: OauthInfo?
    
        /// 第三方授权注册成功后执行的自动登录方法
    var autoLogin: ((parameters: [String: String]) -> ())?
    
    var parameters: [String: String] {
        return [
            "username": accountTextField.text!,
            "password": passwordTextField.text!,
        ]
    }
        /// 授注册成功后返回的信息，主要是userid和cookie用于论坛同步
    var registeReturnInfo: RegisteReturnInfo!
        /// 仅仅用于注册后同步论坛
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
        setOauthRegister()
    }
    
    deinit {
        dPrint("Register deinit")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
}

extension RegisterController {
    /**
     设置第三方登录的注册信息
     只有是第三方登录后跳转的注册才会完整执行代码
     */
    func setOauthRegister() {
        guard let oauthInfo = oauthInfo else {
            return
        }
        
        nicknameTextField.text = oauthInfo.username
        oauthInfoLabel.hidden = false
        oauthInfoLabel.text = "[\(oauthInfo.username)]已验证成功，请继续完成注册！稍后您便可以直接通过\(oauthInfo.platformName.uppercaseString)登录或使用ID密码登录。"
        nickNameDidChange()
    }
    
    /**
     根据相应注册信息，设置相应提示信息
     在每完成一行用户信息后调用
     
     - parameter isValid:     是否合法
     - parameter text:        输入框文本的内容
     - parameter noticeLabel: 提示的标签
     - parameter iconButton:  提示的图标
     - parameter index:       当前索引，用来设置标志位
     */
    func setInvalidNotice(isValid: Bool,
                          text: String,
                          noticeLabel: UILabel,
                          iconButton: UIButton,
                          index: UInt8) {
        
        noticeLabel.hidden = isValid
        iconButton.hidden = text.characters.count == 0
        iconButton.selected = !isValid
        
        isValid ? validCount.setBit(index) : validCount.clrBit(index)
    }
    
    /**
     同步账号
     在注册成功后调用
     */
    func synchronizeBBSAcount() {
        MBProgressHUD.showMessage("注册成功!\n 正在同步论坛账号...")
        
        func reponse(result: Bool) {
            if result == true {
                MBProgressHUD.showSuccess("同步成功!")
            }else {
                MBProgressHUD.showError("同步失败!稍后尝试")
            }
            completeRegiste()
        }
        
        func failure(error: ErrorType) {
            MBProgressHUD.hideHUD()
            let alert = UIAlertController(title: "失败", message: "与论坛同步失败！\n部分功能无法使用，是否重试？", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "取消",
                                       style: .Default) { _ in
                                        MBProgressHUD.showWarning("注册成功！稍后为您进行同步!")
                                        self.completeRegiste()
            }
            let reTry = UIAlertAction(title: "重试",
                                      style: .Default) { _ in
                                        self.synchronizeBBSAcount()
            }
            alert.addAction(cancel)
            alert.addAction(reTry)
            presentViewController(alert, animated: true, completion: nil)
        }
        
        UserManager.sharedInstance
            .synchronizeBBSAcount(registeReturnInfo!,
                                success: reponse,
                                failure: failure)
    }
    
    /**
     完成注册操作，可能同步成功，也可能同步失败
     */
    func completeRegiste() {
        if oauthInfo != nil {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(500 * USEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                self.autoLogin?(parameters: self.parameters)
            }
        }else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
}

// MARK: - 监听方法
extension RegisterController {
    
    @IBAction func registerButtonClik() {
        
        func sccess(userID: Int, cookie: String) {
            registeReturnInfo = (userID, cookie)
            synchronizeBBSAcount()
        }
        
        func failure(error: ErrorType) {
            switch error as! Error {
            case .RegisterError(let errorInfo):
                MBProgressHUD.showError(errorInfo)
            case .NetworkError:
                MBProgressHUD.showError("网络拥堵，请稍后尝试")
            default:
                break
            }
        }
        
        MBProgressHUD.showMessage("正在验证...")
        UserManager.register(
            (nicknameTextField.text!,
                emailTextField.text!,
                accountTextField.text!,
                passwordTextField.text!,
                oauthInfo
            ),
            success: sccess,
            failure: failure)
    }
    @IBAction func backButtonClik() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func nickNameDidChange() {
        
        guard let nickname = nicknameTextField.text else {
            return
        }
        
        setInvalidNotice(nickname.characters.count > 0 ,
                         text: nickname,
                         noticeLabel: nicknameErrorInfo,
                         iconButton: nicknameValidLogo,
                         index: UInt8(nicknameValidLogo.tag))
    }

    @IBAction func emailDidChange() {
        guard let email = emailTextField.text else {
            return
        }
        let patten = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = RegexHelper(patten)
        
        setInvalidNotice(matcher.match(email),
                         text: email,
                         noticeLabel: emailErrorInfo,
                         iconButton: emailValidLogo,
                         index: UInt8(emailValidLogo.tag))
        emailErrorInfo.text = "(请填写正确的邮箱地址!)"
    }
    @IBAction func emailDidEndEditing() {
        guard let email = emailTextField.text where emailErrorInfo.hidden && !email.isEmpty else {
            return
        }
        
        func success(isExists: Bool) {
            emailActivityView.hidden = true
            emailValidLogo.hidden = false
            if isExists {
                setInvalidNotice(false,
                                 text: email,
                                 noticeLabel: emailErrorInfo,
                                 iconButton: emailValidLogo,
                                 index: UInt8(emailValidLogo.tag))
                emailErrorInfo.text = "(邮箱已被注册!)"
            }
        }
        
        func failure(_: ErrorType) {
            emailActivityView.hidden = true
            emailValidLogo.hidden = false
        }
        emailActivityView.hidden = false
        emailValidLogo.hidden = true
        UserManager.checkEmailValid(email,
                                    success: success,
                                    failure: failure)
    }
    
    @IBAction func accountDidChange() {
        guard let account = accountTextField.text else {
            return
        }
        
        let patten = "^[a-zA-z][a-zA-Z0-9_.\\-@]{2,17}$"
        let matcher = RegexHelper(patten)
        
        setInvalidNotice(matcher.match(account),
                         text: account,
                         noticeLabel: accountErrorInfo,
                         iconButton: accountValidLogo,
                         index: UInt8(accountValidLogo.tag))
        accountErrorInfo.text = "(账号格式不正确!)"
    }
    @IBAction func accountDidEndEditing() {
        guard let account = accountTextField.text where accountErrorInfo.hidden && !account.isEmpty else {
            return
        }
        func success(isExists: Bool) {
            accountActivityView.hidden = true
            accountValidLogo.hidden = false
            if isExists {
                setInvalidNotice(false,
                                 text: account,
                                 noticeLabel: accountErrorInfo,
                                 iconButton: accountValidLogo,
                                 index: UInt8(accountValidLogo.tag))
                accountErrorInfo.text = "(用户已存在!)"
            }
        }
        
        func failure(_: ErrorType) {
            accountActivityView.hidden = true
            accountValidLogo.hidden = false
        }
        accountActivityView.hidden = false
        accountValidLogo.hidden = true
        UserManager.checkAccountValid(account,
                                      success: success,
                                      failure: failure)
    }

    @IBAction func passwordDidChange() {
        guard let password = passwordTextField.text else {
            return
        }
        
        setInvalidNotice(password.characters.count >= 7,
                         text: password,
                         noticeLabel: passwordErrorInfo,
                         iconButton: passwordValidLogo,
                         index:  UInt8(passwordValidLogo.tag))
        againPasswordDidChange()
    }
    @IBAction func againPasswordDidChange() {
        guard let againPassword = againPasswordTextField.text,
            password = passwordTextField.text  else {
            return
        }
        
        setInvalidNotice(againPassword == password,
                         text: password,
                         noticeLabel: againPasswordErrorInfo,
                         iconButton: againPasswordValidLogo,
                         index: UInt8(againPasswordValidLogo.tag))
    }
}


private extension UInt8 {
    mutating func setBit(index: UInt8) {
        self |= (1 << index)
    }
    
    mutating func clrBit(index: UInt8) {
        self &= ~(1 << index)
    }
}
