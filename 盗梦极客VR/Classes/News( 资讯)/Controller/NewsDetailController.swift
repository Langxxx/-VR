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
        setupTableView()
        setupWebView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
}

extension NewsDetailController {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.sectionHeaderHeight = 25
        tableView.sectionFooterHeight = 0
        tableView.hidden = true
    }
    
    func setupWebView() {
        webView = UIWebView()
        webView.delegate = self
        webView.scrollView.scrollEnabled = false
        loadNewsDetail()
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
// MARK: - 监听方法
extension NewsDetailController {
    @IBAction func backButtonClik() {
        navigationController?.popViewControllerAnimated(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func shareButtonClik() {
        
        ShareTool.setAllShareConfig(newsModel.title, shareText: newsModel.excerpt, url: newsModel.url)
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: nil, shareText: nil, shareImage: ShareTool.shareImage, shareToSnsNames: ShareTool.shareArray, delegate: nil)
    }
}

// MARK: - webView代理
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
        let str = webView
            .stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")!
        let height = CGFloat((str as NSString).doubleValue)
        webView.frame.size.height = height + 20 //为了去除获得高度的偏差造成影响所以+20
        let webViewIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        tableView.reloadRowsAtIndexPaths([webViewIndexPath], withRowAnimation: .None)
        tableView.scrollToRowAtIndexPath(webViewIndexPath, atScrollPosition: .Top, animated: false)
        
        // 延迟0.5S再显示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(500 * USEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.tableView.hidden = false
        }
    }

}
// MARK: - tableview代理和数据源
extension NewsDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : newsModel.bbsInfo.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = indexPath.section == 0 ? webCellIdentifier : replyCellIdentifier
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            cell.contentView.addSubview(webView)
            webView.frame = cell.bounds
            
        }else {
            let postModel = newsModel.bbsInfo.posts[indexPath.row]
            let replyCellViewModel = ReplyCellViewModel(model: postModel)
            (cell as! ReplyCell).configure(replyCellViewModel)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return webView.frame.height
        }else {
            return UITableViewAutomaticDimension
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 && newsModel.bbsInfo.posts.count != 0 else {
            return nil
        }
        
        let attriStr = NSMutableAttributedString(string: "  用户评论")
        let redStrAttr = [NSForegroundColorAttributeName : UIColor.redColor()]
        attriStr.addAttributes(redStrAttr, range: NSRange(location: 0, length: attriStr.length))
        let label = UILabel()
        label.attributedText = attriStr
        label.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        label.font = UIFont.systemFontOfSize(15)
        return label
    }
}

