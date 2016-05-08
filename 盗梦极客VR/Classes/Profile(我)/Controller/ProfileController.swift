//
//  ProfileController.swift
//  盗梦极客VR
//
//  Created by wl on 5/5/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var exitContainerView: UIView!
    
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
}

extension ProfileController {

    func setupUserInfo() {
        guard let user = user else {
            return
        }
        
        loginButton.enabled = false
        
        avatarImageView.sd_setImageWithURL(NSURL(string: user.avatar)!)
        avatarImageView.layer.cornerRadius =  avatarImageView.bounds.width * 0.5
        usernameLabel.text = user.displayname
        exitContainerView.hidden = false
    }
}

extension ProfileController {
    
    @IBAction func loginButtonClik() {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        vc.completion = { user in
            self.user = user
        }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
    }
    
    @IBAction func exitButtonClik() {
        
    }
    
}


extension ProfileController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("test", forIndexPath: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
}