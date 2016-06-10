//
//  BBSController.swift
//  盗梦极客VR
//
//  Created by wl on 4/20/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import MBProgressHUD

class BBSController: UIViewController {
    
    var webView: WKWebView!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var reloadLabel: UILabel!
    
    var user: User? {
        return UserManager.sharedInstance.user
    }
    
        /// 首页跳转来的URL
    var jumpURL: String? {
        didSet {
            if jumpURL != nil {
                needJump = true
            }
        }
    }
        /// 是否需要进跳转的标识
    var needJump = false
        /// 跳转请求
    var jumpRequest: NSURLRequest {
        return NSURLRequest(URL: NSURL(string: jumpURL!)!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15)
    }
        /// 是否正在登陆论坛
    var isLoginingBBSURL = false
        /// 是否是第一次进行请求加载
    var isFirstRequste = true
        /// 请求
    var request: NSURLRequest {
        return NSURLRequest(URL: NSURL(string: getBaseURL())!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15)
    }
    /// 当前加载(跳转、登陆)提示的URL，若不是前面的操作，则为空
    var MBPMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reEnterForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    /**
     只有webView加载失败，此方法才能被调用，
     点击视图重新加载
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !webView.loading {
            webView.loadRequest(request)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
        
        if let meassge = MBPMessage {
            MBProgressHUD.showMessage(meassge, toView: view)
        }
        
        if webView.loading { return }
        
        if isFirstRequste && !needJump {
            webView.loadRequest(request)
        }else if UserManager.sharedInstance.needAutoLoginBSS && !isLoginingBBSURL {
            webView.loadRequest(request)
        }else if needJump {
            webView.loadRequest(jumpRequest)
        }
    }
 
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MBProgressHUD.hideHUD(view)
    }
    
}

// MARK: - 初始化方法
extension BBSController {
    
    /**
     设置webview
     */
    func setupWebView() {
        
        let configuretion = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: CGRectZero, configuration: configuretion)
        webView.hidden = true
        //允许手势，后退前进等操作
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
        self.webView = webView
        
        webView.snp_makeConstraints { (make) in
            make.top.equalTo(self.progressView.snp_bottom)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        webView.navigationDelegate = self
        webView.UIDelegate = self
        // 监听加载进度
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        //监听是否可以前进后退，修改btn.enable属性
        //        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        
        //        webView.loadRequest(request)
    }
    
}

// MARK: - 功能性方法
extension BBSController {
    
    /**
     获得请求连接URL
     */
    func getBaseURL() -> String {
        // 如果已经登陆且没有登录过论坛，则自动登陆论坛
        if UserManager.sharedInstance.needAutoLoginBSS {
            isLoginingBBSURL = true
            if let cookie = user?.cookie, userID = user?.id {
                return "http://dmgeek.com/login/?action=login_bbs&cookie=\(cookie)&user_id=\(userID)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            }else {
                dPrint("getBaseURL error!")
                return "http://bbs.dmgeek.com"
            }
        }else {
            return "http://bbs.dmgeek.com"
        }
    }
    /**
     重新加载当前页面
     当用程序从后台进入前台的时候调用
     */
    func reEnterForeground() {
        webView.reload()
    }
    
    /**
     分享当前界面
     当界面发生分享事件的时候调用
     */
    func shareCurrentURL() {
        guard let title = webView.title?.componentsSeparatedByString(" - ").first else {
            MBProgressHUD.showError("网页存在错误")
            return
        }
        ShareTool.setAllShareConfig(title, shareText: "来自盗梦极客为您推荐的内容", url: webView.URL!.absoluteString)
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: nil, shareText: nil, shareImage: ShareTool.shareImage, shareToSnsNames: ShareTool.shareArray, delegate: nil)
    }

    /**
     用来请求前的一些准备操作
     每次进行请求加载的时候调用
     */
    func prepareLoadRequst() {
        dPrint("prepareLoadRequst")
        reloadLabel.hidden = true
        progressView.hidden = false
        progressView.progress = 0
        
        if MBPMessage != nil { return }
        if isLoginingBBSURL {
            MBPMessage = "正在同步用户数据..."
            MBProgressHUD.showMessage(MBPMessage!, toView: view)
        }else if needJump {
            MBPMessage = "正在跳转链接..."
            MBProgressHUD.showMessage(MBPMessage!, toView: view)
        }
    }
    
    /**
     使用OtherLinkWebController加载链接
     当点击了外部链接的时候调用
     
     - parameter urlStr: 链接
     */
    func jumpToOtherLinker(urlStr: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OtherLinkWebController") as! OtherLinkWebController
        vc.URLStr = urlStr
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - WKUIDelegate
extension BBSController: WKUIDelegate {
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        if message == "app_share" {
            shareCurrentURL()
        }
        completionHandler()
    }
}

// MARK: - WKNavigationDelegate
extension BBSController: WKNavigationDelegate {

    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.loadRequest(navigationAction.request)
        return nil
    }

    /**
     处理跳转的URL，如果不是期待
     的url则跳转到safari
     */
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

//        dPrint(navigationAction.request.URLString)
        guard let targetFrame = navigationAction.targetFrame,
            requstURL = navigationAction.request.URL else {
                decisionHandler(.Cancel)
                return
        }
        if targetFrame.mainFrame
            && !isExpectedURL(requstURL.absoluteString) {
            decisionHandler(.Cancel)
            jumpToOtherLinker(requstURL.absoluteString)
        }else {
            if targetFrame.mainFrame {
                prepareLoadRequst()
            }
            decisionHandler(.Allow)
        }
       
    }
    
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        dPrint("正在加载...")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        dPrint("加载成功...")
        MBProgressHUD.hideHUD(view)
        MBPMessage = nil
        progressView.hidden = true
        webView.hidden = false
        isFirstRequste = false
        if isLoginingBBSURL {
            //进行到这里，表示是自动登录论坛成功
            isLoginingBBSURL = false
            UserManager.sharedInstance.bbsIsLogin = true
            if needJump {
                webView.loadRequest(jumpRequest)
            }

        }else if needJump {
            needJump = false
        }
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        MBProgressHUD.hideHUD(view)
        MBPMessage = nil
        reloadLabel.hidden = false
        progressView.hidden = true
        // 102可能是程序中断(内部跳转)
        if error.code != 102 {
            MBProgressHUD.showError("网络拥堵，请稍后尝试！")
        }
    }
    
}
