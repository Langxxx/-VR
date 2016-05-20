//
//  ReplyController.swift
//  盗梦极客VR
//
//  Created by wl on 5/12/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ReplyController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!

    let user = UserManager.sharedInstance.user!
    var newsModel: NewsModel!
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ReplyController {
    
    @IBAction func sendButtonClik() {
        Alamofire.request(.POST, "http://bbs.dmgeek.com/posts", parameters: parameters, headers: headers)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print("post reply error!\n URL:\(response.result.error)")
                    return
                }
                if let (_, error) = JSON(response.result.value!)["errors"].first {
                    MBProgressHUD.showError(error.stringValue)
                }else {
                    MBProgressHUD.showSuccess("您的回复已经提交")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
        }
    }
    
    @IBAction func cancelButtonClik() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(noti: NSNotification) {
        
        if textView.text.characters.count > 8 {
            sendButton.enabled = true
        }else {
            sendButton.enabled = false
        }
    }
}
