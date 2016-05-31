//
//  ProfileController.swift
//  盗梦极客VR
//
//  Created by wl on 5/5/16.
//  Copyright © 2016 wl. All rights reserved.
//  我模块

import UIKit
import SDWebImage
import MBProgressHUD

class ProfileController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var exitContainerView: UIView!
    
        /// 用户数据模型
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
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: - 初始化方法
extension ProfileController {
    /**
     设置tabview
     */
    func setupTableView() {
        tableView.dataSource = staticCellProvider
        tableView.delegate = staticCellProvider
        tableView.registerClass(StaticCell.self, forCellReuseIdentifier: staticCellProvider.cellID)
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        addLastGroup()
        
        if user != nil {
            setupUserInfo()
        }
    }
    
    /**
     设置需要展示的用户数据
     */
    func setupUserInfo() {
        guard let user = user else {
            return
        }
        
        loginButton.enabled = false
        
        avatarImageView.sd_setImageWithURL(NSURL(string: user.avatar)!)
        avatarImageView.layer.cornerRadius =  avatarImageView.bounds.width * 0.5
        avatarImageView.layer.masksToBounds = true
        usernameLabel.text = user.displayname
        exitContainerView.hidden = false
        
        addGroup0()
        tableView.reloadData()
        view.setNeedsDisplay()
    }
    /**
     清理所有的用户数据
     点击退出登录后调用
     */
    func clearUserInfo() {
        loginButton.enabled = true
        
        avatarImageView.image = UIImage(named: "user_defaultavatar")
        usernameLabel.text = "点击登录"
        exitContainerView.hidden = true
    }
    
    /**
     添加第一组数据显示(用户数据)
     */
    func addGroup0() {
        let account = RightDetallCellModel(text: "账号", rightDetall: user.username)
        let nickname = RightDetallCellModel(text: "昵称", rightDetall: user.displayname)
        let email = RightDetallCellModel(text: "邮箱", rightDetall: user.email)
        let group = CellGroup(header: "基本信息", items: [account, nickname, email], footer: "此版本暂不支持修改个人信息")
        staticCellProvider.dataList.insert(group, atIndex: 0)
    }
    /**
     添加最后一组数据显示(功能数据)
     */
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

// MARK: - 监听方法
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
