//
//  ReplyController.swift
//  盗梦极客VR
//
//  Created by wl on 5/12/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class ReplyController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!

    let user = UserManager.sharedInstance.user!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = user.username
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ReplyController {
    @IBAction func sendButtonClik() {
    }
    @IBAction func cancelButtonClik() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
