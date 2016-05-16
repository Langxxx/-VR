//
//  RegisterController.swift
//  盗梦极客VR
//
//  Created by wl on 5/16/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var againPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension RegisterController {
    @IBAction func registerButtonClik() {
    }
    @IBAction func backButtonClik() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
