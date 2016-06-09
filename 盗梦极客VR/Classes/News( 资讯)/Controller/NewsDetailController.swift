//
//  NewsDetailController.swift
//  盗梦极客VR
//
//  Created by wl on 4/26/16.
//  Copyright © 2016 wl. All rights reserved.
//  新闻详情

import UIKit
import MBProgressHUD
import MJRefresh

class NewsDetailController: UIViewController, DetailVcJumpable {
    
    /// 这里不使用WKWebView是因为Loadhtml方法加载出来的，样式会很奇怪
    @IBOutlet weak var tableView: UITableView!
        /// 底部评论界面
    @IBOutlet weak var replyContainerView: UIView!
        /// 评论数量的label
    @IBOutlet weak var replyCountLabel: UILabel!
    
    var webView: UIWebView!
        /// 当前新闻模型
    var newsModel: NewsModel!
    
    let webCellIdentifier = "WebCell"
    let replyCellIdentifier = "ReplyCell"
    let deviceCellIdentifier = "DeviceCell"
    
        /// 当前新闻是否是设备新闻
    var isDeviceList: Bool {
        return newsModel.type == "device"
    }
        /// 设备新闻的所有相关新闻模型
    var newsModelArray: [NewsModel] = []
        /// 设备新闻请求URL
    let deviceURL = "http://dmgeek.com/DG_api/get_device_posts/"
        /// 设备新闻请求参数
    var parameters: [String: AnyObject] {
        return [
            "page": deviceListPage,
            "post_id": newsModel.id,
            "post_type": "device"
        ]
    }
    var deviceListPage = 1
    
        /// 当前界面是否需要评论功能
    var canReply: Bool {
        return !(newsModel.type == "device" || newsModel.type == "video")
    }
    
        /// 所有可能的视频来源
    let videoRequestList = [
        "http://player.youku.com/",
        "http://v.qq.com/",
        "http://play.video.qcloud.com/",
        "http://www.tudou.com",
        "http://tv.sohu.com",
        "http://www.acfun.tv",
        "http://www.bilibili.com"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupWebView()
        
        if isDeviceList {
            tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadDeviceListInfo))
            tableView.mj_footer.beginRefreshing()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // 若不停止任务，IOS8中会崩溃
        currentTask?.cancel()
    }
    
    deinit {
        dPrint("NewsDetailController deinit")
    }
}

// MARK: -  初始化方法
extension NewsDetailController {
    /**
     设置setupTableView
     */
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        tableView.hidden = true
    }
    /**
     设置WebView
     */
    func setupWebView() {
        webView = UIWebView()
        webView.delegate = self
        webView.scrollView.scrollEnabled = false
        loadNewsDetail()
    }

}


// MARK: - 功能性方法
extension NewsDetailController {
    /**
     加载设备列表数据
     */
    func loadDeviceListInfo() {
        
        func success(modelArray: [NewsModel]) {
            tableView.mj_footer.endRefreshing()
            guard modelArray.count != 0 else {
                MBProgressHUD.showError("没有更多信息")
                return
            }
            newsModelArray += modelArray
            deviceListPage += 1
            let section = NSIndexSet(index: 1)
            tableView.reloadSections(section, withRowAnimation: .None)
            
        }
        
        func failure(error: ErrorType) {
            tableView.mj_footer.endRefreshing()
            switch error as! Error {
            case .UserInterrupt:
                break
            default:
                MBProgressHUD.showError("网络拥堵，请稍后尝试!")
            }
        }
        
        fetchJsonFromNet(deviceURL, parameters)
            .map { jsonToModelArray( $0["posts"], initial: NewsModel.init) }
            .complete(success: success, failure: failure)
        
    }
    /**
     判断请求是否是视频链接
     
     - parameter urlStr: 需要判断的请求
     
     */
    func isVideoRequst(urlStr: String) -> Bool {
        for str in videoRequestList {
            if urlStr.hasPrefix(str) {
                return true
            }
        }
        return false
    }
    
    /**
     外部链接跳转
     当点击页面内链接后调用
     
     - parameter urlStr: <#urlStr description#>
     */
    func jumpToOtherLinker(urlStr: String) {
        // TODO: 内部链接应该跳转到论坛模块
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OtherLinkWebController") as! OtherLinkWebController
        vc.URLStr = urlStr
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     加载HTML
     */
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
    /**
     拼接body
     */
    func getBody() -> String {
        var body = ""
        
        body += isDeviceList ? "<body style=\"background-color:#fff\">" : "<body>"
        
        body += "<div class=\"title\">"
        body += newsModel.title
        body += "</div>"
        
        body += "<div class=\"time\">"
        body += newsModel.date
        body += "</div>"
        
        body += newsModel.content.stringByReplacingOccurrencesOfString("\r\n", withString: "<br/>")
        
        if let str = newsModel.taxonomyVideos.first?.title where str == "全景视频" {
            body += "<h4 style=\"color:#cc0000\">优酷全景视频暂不支持手机播放，请尝试在PC端观看</h4>"
        }
        
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
    
    @IBAction func replyButtonClik() {
        
        if UserManager.sharedInstance.user == nil { //未登录
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewControllerWithIdentifier("LoginController") as! LoginController
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
                interactivePopGestureRecognizer.delegate = nil
            }
        }else {
            let vc = UIStoryboard(name: "News", bundle: nil).instantiateViewControllerWithIdentifier("ReplyController") as! ReplyController
            vc.newsModel = newsModel
            presentViewController(vc, animated: true, completion: nil)
        }
        
    }

    func loadMoreReplyButtonClik() {
        guard let navVc = tabBarController!.viewControllers?[1] as? UINavigationController else {
            return
        }
        let bbsvc = navVc.topViewController as? BBSController
        bbsvc?.jumpURL = newsModel.customFields.discoursePermalink.first

        tabBarController?.selectedViewController = navVc
    }
    
    @IBAction func lookupReplyButtonClik() {
        if newsModel.bbsInfo.posts.count > 0 {
            let indexPath = NSIndexPath(forRow: 0, inSection: 1)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }
    
}

// MARK: - webView代理
extension NewsDetailController: UIWebViewDelegate {
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MBProgressHUD.showError("网络异常，请稍后尝试！")
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlStr = request.URL!.absoluteString
        if urlStr == "about:blank" || isVideoRequst(urlStr) {
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
            if self.canReply {
                self.replyContainerView.hidden = false
                let replyCount = self.newsModel.customFields.discourseCommentsCount.first ?? "0"
                self.replyCountLabel.text = "\(replyCount) 跟帖"
            }
        }
    }

}
// MARK: - tableview代理和数据源
extension NewsDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isDeviceList {
            return section == 0 ? 1 : newsModel.bbsInfo.posts.count
        }else {
            return section == 0 ? 1 : newsModelArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(webCellIdentifier, forIndexPath: indexPath)
            cell.contentView.addSubview(webView)
            webView.frame = cell.bounds
            return cell
            
        }else {
            
            let identifier = isDeviceList ? deviceCellIdentifier : replyCellIdentifier
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
            
            if isDeviceList {
                let newsModel = newsModelArray[indexPath.row]
                let deviceCellViewModel = DeviceCellViewModel(model: newsModel)
                (cell as! DeviceCell).configure(deviceCellViewModel)
            }else {
                let postModel = newsModel.bbsInfo.posts[indexPath.row]
                let replyCellViewModel = ReplyCellViewModel(model: postModel)
                (cell as! ReplyCell).configure(replyCellViewModel)
                (cell as! ReplyCell).delegate = self
                cell.selectionStyle = .None
                cell.frame = tableView.bounds
            }
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return webView.frame.height
        }else {
            return isDeviceList ? 100 : UITableViewAutomaticDimension
        }
    }

//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard section != 0 && newsModel.bbsInfo.posts.count != 0 else {
//            return nil
//        }
//        
//        let attriStr = NSMutableAttributedString(string: "  用户评论")
//        let redStrAttr = [NSForegroundColorAttributeName : UIColor.redColor()]
//        attriStr.addAttributes(redStrAttr, range: NSRange(location: 0, length: attriStr.length))
//        let label = UILabel()
//        label.attributedText = attriStr
//        label.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
//        label.font = UIFont.systemFontOfSize(15)
//        return label
//    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section != 0 else {
            return nil
        }
        
        if isDeviceList {
            return "相关文章"
        }else if newsModel.bbsInfo.posts.count != 0 {
            return "论坛热点评论"
        }else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section != 0 && newsModel.bbsInfo.posts.count >= 9 else {
            return 0
        }
        return 40
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section != 0 && newsModel.bbsInfo.posts.count >= 5 else {
            return nil
        }
        let view = UIView()
        let button = UIButton()
        button.setTitle("更多评论，请点击此处", forState: .Normal)
        view.addSubview(button)
        button.snp_makeConstraints { (make) in
            make.top.equalTo(view).offset(5)
            make.bottom.equalTo(view)
            make.right.equalTo(view).offset(-10)
            make.left.equalTo(view).offset(10)
        }

        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setBackgroundImage(UIImage(named: "account_logout_button"), forState: .Normal)
        button.addTarget(self, action: #selector(loadMoreReplyButtonClik), forControlEvents: .TouchUpInside)
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isDeviceList {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            pushDetailVcBySelectedNewsModel(newsModelArray[indexPath.row])
        }
    }
}

extension NewsDetailController: ReplyCellDelegate {

    func replyCell(cell: ReplyCell, linkDidPress link: NSURL) {
        jumpToOtherLinker(link.URLString)
    }
    
    func replyCellSizeDidChange(cell: ReplyCell) {
        if let _ = tableView.indexPathForCell(cell) {
            tableView.reloadData()
        }
    }
}
