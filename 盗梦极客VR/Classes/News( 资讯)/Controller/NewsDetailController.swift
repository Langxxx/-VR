//
//  NewsDetailController.swift
//  盗梦极客VR
//
//  Created by wl on 4/26/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import MBProgressHUD
import SnapKit

class NewsDetailController: UIViewController {
    
    /// 这里不使用WKWebView是因为Loadhtml方法加载出来的，样式会很奇怪
    @IBOutlet weak var tableView: UITableView!
    
    var webView: UIWebView!
    var newsModel: NewsModel!
    
    let webCellIdentifier = "WebCell"
    let replyCellIdentifier = "ReplyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        automaticallyAdjustsScrollViewInsets = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        webView = UIWebView()
        webView.delegate = self
        webView.scrollView.scrollEnabled = false
        loadNewsDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        print("deinit")
    }
    
    @IBAction func backButtonClik() {
        navigationController?.popViewControllerAnimated(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func shareButtonClik() {
        
        ShareTool.setAllShareConfig(newsModel.title, shareText: newsModel.excerpt, url: newsModel.url)
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: nil, shareText: nil, shareImage: ShareTool.shareImage, shareToSnsNames: ShareTool.shareArray, delegate: nil)
    }
    
}

extension NewsDetailController: UIWebViewDelegate {
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MBProgressHUD.showError("网络异常，请稍后尝试！")
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlStr = request.URL!.absoluteString
        if urlStr == "about:blank" || urlStr.hasPrefix("http://player.youku.com/") || urlStr.hasPrefix("http://v.qq.com/iframe/player.html") {
            return true
        }

        jumpToOtherLinker(request.URLString)
        return false
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        let str = webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")!
        let height = CGFloat((str as NSString).doubleValue)
        webView.frame.size.height = height
        tableView.reloadData()
    }

}

extension NewsDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.bbsInfo.posts.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = indexPath.row == 0 ? webCellIdentifier : replyCellIdentifier
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if indexPath.row == 0 {
            cell.contentView.addSubview(webView)
            webView.frame = cell.bounds
            
        }else {
            let postModel = newsModel.bbsInfo.posts[indexPath.row - 1]
            let replyCellViewModel = ReplyCellViewModel(model: postModel)
            (cell as! ReplyCell).configure(replyCellViewModel)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return webView.frame.height
        }else {
            return UITableViewAutomaticDimension
        }
    }
}

extension NewsDetailController {
    
    func jumpToOtherLinker(urlStr: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OtherLinkWebController") as! OtherLinkWebController
        vc.URLStr = urlStr
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadNewsDetail() {
        
        let css = NSBundle.mainBundle().URLForResource("Details.css", withExtension: nil)!
        
        var html = "<html>"
        
        html += "<head>"
        html += "<link rel=\"stylesheet\" href="
        html += "\"\(css)\""
        html += ">"
        html += "</head>"
        html += getBody()
        html += "</html>"
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func getBody() -> String {
        var body = "<body>"
        
        body += "<div class=\"title\">"
        body += newsModel.title
        body += "</div>"
        
        body += "<div class=\"time\">"
        body += newsModel.date
        body += "</div>"
        
        body += newsModel.content
        
        body += "</body>"
        
        return body
    }
    
}
