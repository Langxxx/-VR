//
//  RegisterController.swift
//  盗梦极客VR
//
//  Created by wl on 5/16/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import IQKeyboardManager

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
    
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler!

    var validCount: UInt8 = 0b00000000 {
        didSet {
            if validCount == 0b00011111 {
                registerButton.enabled = true
            }else {
                registerButton.enabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}

extension RegisterController {
    
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
    
}

extension RegisterController {
    @IBAction func registerButtonClik() {
        
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
