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
import SVProgressHUD

class BBSController: UIViewController {
    
    var webView: WKWebView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    let baseURL = "http://bbs.dmgeek.com"
    
    var request: NSURLRequest {
        return NSURLRequest(URL: NSURL(string: baseURL)!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.sizeToFit()
        setupWebView()
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
        webView.loadRequest(request)
    }
}

extension BBSController {
    
    func setupWebView() {
        
        let configuretion = WKWebViewConfiguration()

        let webView = WKWebView(frame: CGRectZero, configuration: configuretion)
        webView.hidden = true
        view.addSubview(webView)
        self.webView = webView
        
        webView.snp_makeConstraints { (make) in
            make.top.equalTo(self.progressView)
            make.bottom.equalTo(self.view).offset(-44)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        webView.navigationDelegate = self

        // 监听加载进度
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.loadRequest(request)
    }
}


extension BBSController: WKNavigationDelegate {

    /**
     处理跳转的URL，如果不是http://bbs.dmgeek.com子域名
     的url则跳转到safari
     */
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        guard let targetFrame = navigationAction.targetFrame,
            requstURL = navigationAction.request.URL else {
                decisionHandler(.Cancel)
                return
        }
        print(requstURL)
        if targetFrame.mainFrame
            && !isExpectedURL(requstURL.absoluteString) {
            decisionHandler(.Cancel)
            UIApplication.sharedApplication().openURL(requstURL)
        }else {
            decisionHandler(.Allow)
        }
       
    }
    
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("正在加载...")
        
        progressView.hidden = false
        progressView.progress = 0
        SVProgressHUD.showWithStatus("正在加载...")
        SVProgressHUD.setDefaultMaskType(.Clear)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("加载成功...")
        
        SVProgressHUD.dismiss()
        progressView.hidden = true
        webView.hidden = false
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("加载失败")
        SVProgressHUD.showErrorWithStatus("网络拥堵，请稍后尝试！")
        progressView.hidden = true
    }
    
}
