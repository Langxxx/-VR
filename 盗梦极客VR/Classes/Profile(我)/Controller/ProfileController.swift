//
//  ProfileController.swift
//  盗梦极客VR
//
//  Created by wl on 5/5/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class ProfileController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var exitContainerView: UIView!
    
    
    var user: User! {
        get {
            return UserManager.sharedInstance.user
        }
    }
    
    var staticCellProvider =  TableViewProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userDidLogin), name: UserDidLoginNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userDidLoginout), name: UserDidLoginoutNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension ProfileController {

    func setupTableView() {
        tableView.dataSource = staticCellProvider
        tableView.delegate = staticCellProvider
        tableView.registerClass(StaticCell.self, forCellReuseIdentifier: staticCellProvider.cellID)
        
        addLastGroup()
        
        if user != nil {
            setupUserInfo()
        }
    }
    
    func setupUserInfo() {
        guard let user = user else {
            return
        }
        
        loginButton.enabled = false
        
        avatarImageView.sd_setImageWithURL(NSURL(string: user.avatar)!)
        avatarImageView.layer.cornerRadius =  avatarImageView.bounds.width * 0.5
        usernameLabel.text = user.displayname
        exitContainerView.hidden = false
        
        addGroup0()
        tableView.reloadData()
    }
    
    func clearUserInfo() {
        loginButton.enabled = true
        
        avatarImageView.image = UIImage(named: "user_defaultavatar")
        usernameLabel.text = "点击登录"
        exitContainerView.hidden = true
    }
    
    func addGroup0() {
        let nickname = RightDetallCellModel(text: "昵称", rightDetall: user.nickname)
        let group = CellGroup(header: "基本信息", items: [nickname])
        staticCellProvider.dataList.insert(group, atIndex: 0)
    }
    
    func addLastGroup() {
        let clearCell = RightDetallCellModel(text: "清理缓存", rightDetall: SDImageCache.getCacheSizeMB()) {
            MBProgressHUD.showMessage("正在清理缓存...")
            SDImageCache.sharedImageCache().clearDiskOnCompletion {
                MBProgressHUD.hideHUD()
                self.staticCellProvider.dataList.removeLast()
                self.addLastGroup()
                let section  = NSIndexSet(index: self.staticCellProvider.dataList.count - 1)
                self.tableView.reloadSections(section, withRowAnimation: .None)
            }
            
        }
        let group = CellGroup(header: "功能",items: [clearCell])
        staticCellProvider.dataList.append(group)
    }
}

extension ProfileController {
    
    @IBAction func loginButtonClik() {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
    }
    
    @IBAction func exitButtonClik() {
        staticCellProvider.dataList.removeFirst()
        let firstSection = NSIndexSet(index: 0)
        tableView.deleteSections(firstSection, withRowAnimation: .None)
        
        clearUserInfo()
        UserManager.loginout()
    }
    
    func userDidLogin() {
        setupUserInfo()
    }
    
    func userDidLoginout() {
        clearUserInfo()
    }
    
    
}

extension SDImageCache {
    static func getCacheSizeMB() -> String {
        return String(format: "%.2f MB", Float(SDImageCache.sharedImageCache().getSize() / 1024) / 1024)
    }
}
