//
//  ReplyController.swift
//  盗梦极客VR
//
//  Created by wl on 5/12/16.
//  Copyright © 2016 wl. All rights reserved.
//  评论界面

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ReplyController: UIViewController {
        /// 用户名
    @IBOutlet weak var usernameLabel: UILabel!
        /// 发送按钮
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!

    let user = UserManager.sharedInstance.user!
    var newsModel: NewsModel!
    
        /// 评论参数
    var parameters: [String: AnyObject] {
        return [
            "category": 1,
            "reply_to_post_number": 1,
            "api_key": "78c1d5d32a7f6acc978095c7563f0e7fa9cefef55b9a8ee1d8cde3065bb49460",
            "api_username": user.username,
            "topic_id": newsModel.bbsInfo.id,
            "raw": "<span>\(textView.text)</span>"
        ]
        
    }
    
        /// 请求头
    var headers: [String: String] {
        return [
            "timeout": "30",
            "method": "POST"
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = user.displayname
        textView.becomeFirstResponder()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textViewDidChange(_:)), name: UITextViewTextDidChangeNotification, object: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !user.userCreated {
            view.endEditing(true)
            showNoticeMessage()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - 功能性方法
extension ReplyController {
    
    /**
     提示账号未进行同步
     界面加载的时候进行判断进而调用、同步失败后也会调用

     - parameter message: 提示信息
     */
    func showNoticeMessage(message: String = "该账户未与论坛进行同步,无法进行评论") {
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "取消",
                                   style: .Default) { _ in
                                    self.dismissViewControllerAnimated(true, completion: nil)
        }
        let reTry = UIAlertAction(title: "同步",
                                  style: .Default) { _ in
                                    self.synchronizeBBSAcount()
        }
        alert.addAction(cancel)
        alert.addAction(reTry)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     同步当前账户
     */
    func synchronizeBBSAcount() {
        MBProgressHUD.showMessage("正在同步论坛账号...")
        
        func reponse(result: Bool) {
            if result == true {
                MBProgressHUD.showSuccess("同步成功!")
            }else {
                showNoticeMessage("同步失败")
            }
        }
        
        func failure(error: ErrorType) {
            MBProgressHUD.hideHUD()
            showNoticeMessage("同步失败")
        }
        let info: RegisteReturnInfo = (user.id, user.cookie)
        UserManager.sharedInstance
            .synchronizeBBSAcount(info,
                                  success: reponse,
                                  failure: failure)
    }
    
}

// MARK: - 监听方法
extension ReplyController {
    
    @IBAction func sendButtonClik() {
        MBProgressHUD.showMessage("正在提交...")
        Alamofire.request(.POST, "http://bbs.dmgeek.com/posts", parameters: parameters, headers: headers)
            .responseJSON { response in
                guard response.result.error == nil else {
                    dPrint("post reply error!\n URL:\(response.result.error)")
                    MBProgressHUD.showError("发生未知错误!")
                    return
                }
                if let (_, error) = JSON(response.result.value!)["errors"].first {
                    MBProgressHUD.showError(error.stringValue)
                }else {
                    MBProgressHUD.showSuccess("您的回复已经提交!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
        }
    }
    
    @IBAction func cancelButtonClik() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(noti: NSNotification) {
        
        if textView.text.characters.count > 4 {
            sendButton.enabled = true
        }else {
            sendButton.enabled = false
        }
    }
}
