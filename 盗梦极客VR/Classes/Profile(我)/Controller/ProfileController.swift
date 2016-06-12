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
        
         MobClick.beginLogPageView("我")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("我")
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
        addGroup1()
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
        let nickname = RightDetallWithArrowCellModel(text: "昵称", rightDetall: user.displayname)
        nickname.seletedCallBack = modifyNickname
        let email = RightDetallCellModel(text: "邮箱", rightDetall: user.email)
        let group = CellGroup(header: "基本信息", items: [account, nickname, email], footer: "")
        staticCellProvider.dataList.insert(group, atIndex: 0)
    }
    
    func addGroup1() {
        let clearCell = RightDetallWithArrowCellModel(text: "清理缓存", rightDetall: SDImageCache.getCacheSizeMB()) {
            MBProgressHUD.showMessage("正在清理缓存...")
            SDImageCache.sharedImageCache().clearDiskOnCompletion {
                MBProgressHUD.hideHUD()
                self.staticCellProvider.dataList.removeAtIndex(1)
                self.addGroup1()
                let section  = NSIndexSet(index: 1)
                self.tableView.reloadSections(section, withRowAnimation: .None)
            }
            
        }
        
        let checkVersion = ArrowCellModel(text: "版本更新", icon: nil, seletedCallBack: nil)
        checkVersion.seletedCallBack = checkAppVersion
        
        let group = CellGroup(header: "功能",items: [clearCell, checkVersion])
        staticCellProvider.dataList.append(group)
    }
    
    /**
     添加最后一组数据显示(功能数据)
     */
    func addLastGroup() {
        let aboutMe = ArrowCellModel(text: "关于我们")
        aboutMe.seletedCallBack = {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("AboutMeController")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let mark = ArrowCellModel(text: "给个好评", icon: nil, seletedCallBack: nil)
        mark.seletedCallBack = {
            let url = NSURL(string: "itms-apps://itunes.apple.com/cn/app/dao-meng-ji-kevr/id1118642139?mt=8")!
            UIApplication.sharedApplication().openURL(url)
        }
        let group = CellGroup(header: "其他",items: [mark, aboutMe])
        staticCellProvider.dataList.append(group)
    }
}

extension ProfileController {
    
    func checkAppVersion() {
        MBProgressHUD.showMessage("正在检查版本...", toView:  view)
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        func success(version: String) {
            MBProgressHUD.hideHUD(view)
            if currentVersion == version {
                MBProgressHUD.showWarning("已经是最新版本!", toView: view)
            }else {
                let alert = UIAlertController(title: "更新", message: "是否进行更新?", preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "取消",
                                           style: .Default) { _ in
                }
                let reTry = UIAlertAction(title: "更新",
                                          style: .Default) { _ in
                    let url = NSURL(string: "itms-apps://itunes.apple.com/cn/app/dao-meng-ji-kevr/id1118642139?mt=8")!
                    UIApplication.sharedApplication().openURL(url)
                }
                alert.addAction(cancel)
                alert.addAction(reTry)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        func failure(_: ErrorType) {
            MBProgressHUD.showError("网络错误，请稍后尝试", toView: view)
        }
        
        latestAPPVersion(success, failure: failure)
    }
    
    func updateUserInfo() {
        MBProgressHUD.showMessage("正在更新用户数据...", toView: self.view)
        func success() {
            MBProgressHUD.hideHUD(view)
            staticCellProvider.dataList.removeFirst()
            setupUserInfo()
        }
        
        func failure() {
            MBProgressHUD.hideHUD(view)
            let alert = UIAlertController(title: "错误", message: "网络拥堵，是否重试?", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "取消",
                                       style: .Default) { _ in
            }
            let reTry = UIAlertAction(title: "重试",
                                      style: .Default) { _ in
                                        self.updateUserInfo()
            }
            alert.addAction(cancel)
            alert.addAction(reTry)
            presentViewController(alert, animated: true, completion: nil)
        }
        
        UserManager.updateUserInfo(success, failure: failure)
    }
    
    func modifyNickname() {
        let alert = UIAlertController(title: "修改昵称", message: nil, preferredStyle: .Alert)
        var newName: String = ""
        func success(result: Bool) {
            if result {
                updateUserInfo()
            }else {
                MBProgressHUD.showError("网络拥堵,请稍后尝试！", toView: view)
            }
        }
        
        func failure(_: ErrorType) {
            MBProgressHUD.showError("网络拥堵,请稍后尝试！", toView: view)
        }
        
        alert.addTextFieldWithConfigurationHandler(nil)
        
        let cancel = UIAlertAction(title: "取消", style: .Default, handler: nil)
        let ok = UIAlertAction(title: "确定", style: .Default) { actioin in
            if let nickname = alert.textFields?.first?.text where !nickname.isEmpty {
                    MBProgressHUD.showMessage("正在修改昵称...", toView: self.view)
                    UserManager.sharedInstance.modifyNickname(nickname,success: success, failure: failure)
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
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
