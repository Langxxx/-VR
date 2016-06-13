//
//  SuggestController.swift
//  盗梦极客VR
//
//  Created by wl on 6/12/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import IQKeyboardManager

class SuggestController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler!
    
    var parameters: [String: AnyObject] {
        return [
            "user_id": UserManager.sharedInstance.user?.id ?? "0000",
            "feed_content": textView.text,
            "device_info": "IOS_" + UIDevice.currentDevice().systemVersion,
            "app_ver": NSBundle.currentVersion,
            "contact_mail": emailTextField.text ?? ""
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        let version = NSBundle.currentVersion
        let systemVersion = UIDevice.currentDevice().systemVersion
        versionLabel.text = "系统:\(systemVersion) 客户端版本:\(version)"
//        returnKeyHandler = IQKeyboardReturnKeyHandler(viewController: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        dPrint("SuggestController-deinit")
    }
}

// MARK: - 监听方法
extension SuggestController {
    @IBAction func sendButtonClik() {
        view.endEditing(true)
        MBProgressHUD.showMessage("正在提交...")
        func success(json: JSON) {
            if json["status"].boolValue  {
                MBProgressHUD.showSuccess("提交成功, 感谢您的支持!")
                navigationController?.popViewControllerAnimated(true)
            }else {
                MBProgressHUD.showError("网络错误，请稍后尝试!")
            }
        }
        
        func failure(_: ErrorType) {
            MBProgressHUD.showError("网络错误，请稍后尝试!")
        }
        
        networkRequest("http://dmgeek.com/DG_api/users/feedback_info/", parameters: parameters)
            .complete(success: success, failure: failure)
    }
    
    @IBAction func cancelButtonClik() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
// MARK: - UITextViewDelegate
extension SuggestController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.text.characters.count != 0
        if textView.text.characters.count >= 20 {
            sendButton.enabled = true
        }else {
            sendButton.enabled = false
        }
    }

}