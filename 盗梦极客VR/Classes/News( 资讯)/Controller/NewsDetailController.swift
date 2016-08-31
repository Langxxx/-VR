//
//  NewsDetailController.swift
//  盗梦极客VR
//
//  Created by wl on 6/16/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import MBProgressHUD
import DTCoreText
import MJRefresh

class NewsDetailController: UIViewController, DetailVcJumpable {

    @IBOutlet weak var tableView: UITableView!
    /// 底部评论界面
    @IBOutlet weak var replyContainerView: UIView!
    /// 评论数量的label
    @IBOutlet weak var replyCountLabel: UILabel!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView?
    var newsModel: NewsModel!
    var webView: UIWebView!
    
    /// 设备新闻的所有相关新闻模型
    var newsModelArray: [NewsModel] = []
    
    /// 当前新闻是否是设备新闻
    var isDeviceList: Bool {
        return newsModel.type == "device"
    }
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
        "http://www.bilibili.com",
        "http://music.163.com/",
        "http://video.qq.com/"
    ]
    
    let webCellIdentifier = "WebCell"
    let deviceCellIdentifier = "DeviceCell"
    let replyTitleCellIdentifier = "ReplyTitleCell"
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var cellCache = NSCache()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkRequest("http://dmgeek.com/DG_api/users/update_views?post_id=\(newsModel.id)")
            .complete(success: {_ in }, failure: { _ in })
        
        setupTableView()
        setupWebView()
        
        if isDeviceList {
            tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadDeviceListInfo))
            tableView.mj_footer.beginRefreshing()
        }
        
        //监听程序即将进入前台运行、进入后台休眠 事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    deinit {
        dPrint("Test--deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // 若不停止任务，IOS8中会崩溃
        currentTask?.cancel()
        MobClick.endLogPageView("新闻详情")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
        
        MobClick.beginLogPageView("新闻详情")
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
        tableView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 44, right: 0)
        tableView.hidden = true
        tableView.separatorStyle = .None
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
        
        body += newsModel.content
        
        if let str = newsModel.taxonomyVideos.first?.title where str == "全景视频" {
            body += "<h4 style=\"color:#cc0000\">优酷全景视频暂不支持手机播放，请尝试在PC端观看</h4>"
        }
        
        body += "</body>"
        
        return body
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
     */
    func jumpToOtherLinker(urlStr: String) {
        // TODO: 内部链接应该跳转到论坛模块
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OtherLinkWebController") as! OtherLinkWebController
        vc.URLStr = urlStr
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func prepareCellForIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> HtmlContentCell {
        let key = NSString(format: "%ld-%ld", indexPath.section, indexPath.row)
        var cell = cellCache.objectForKey(key) as? HtmlContentCell
        if cell == nil {
            cell = tableView.dequeueReusableCellWithIdentifier("HtmlContentCell") as? HtmlContentCell
            cell?.hasFixedRowHeight = false
            cellCache.setObject(cell!, forKey: key)
            cell?.delegate = self
            cell?.selectionStyle = .None
        }
        
        let postModel = newsModel.bbsInfo.posts[indexPath.row / 2]
        cell?.setHTMLString("<style>body{color:gray;}p, li {font-family:\"Avenir Next\";font-size:14px;line-height:15px;}a {color: #f25d3c;text-decoration: none;}</style>" + postModel.cooked)
        cell?.attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        cell?.attributedTextContextView.shouldDrawImages = true
        return cell!
    }

}
// MARK: - 监听方法
extension NewsDetailController {
    
    /**
     
     */
    func applicationWillEnterForeground() {
        tableView.reloadData()
    }
    
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
        
        // 延迟0.5S再显示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(500 * USEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.tableView.hidden = false
            
            self.activityView?.hidden = true
            if self.canReply {
                self.replyContainerView.hidden = false
                let replyCount = self.newsModel.customFields.discourseCommentsCount.first ?? "0"
                self.replyCountLabel.text = "\(replyCount) 跟帖"
            }
        }
    }
    
}

extension NewsDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tempIndexPath = NSIndexPath(forRow: 0, inSection: section)
        let type = DetailControllerCellType.analyseCellType(newsModel, indexPath: tempIndexPath)
        switch type {
        case .NewsContent:
            return 1
        case .DeviceNews:
            return newsModelArray.count
        case .Comment(_):
            return newsModel.bbsInfo.posts.count * 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let type = DetailControllerCellType.analyseCellType(newsModel, indexPath: indexPath)
        
        switch type {
        case .NewsContent:
            let cell = tableView.dequeueReusableCellWithIdentifier(webCellIdentifier, forIndexPath: indexPath)
            cell.selectionStyle = .None
            cell.contentView.addSubview(webView)
            webView.frame = cell.bounds
            return cell
        case .DeviceNews:
            let cell = tableView.dequeueReusableCellWithIdentifier(deviceCellIdentifier, forIndexPath: indexPath) as! DeviceCell
            let newsModel = newsModelArray[indexPath.row]
            let deviceCellViewModel = DeviceCellViewModel(model: newsModel)
            cell.configure(deviceCellViewModel)
            return cell
        case .Comment(let replyType):
            if replyType == .Title {
                let cell = tableView.dequeueReusableCellWithIdentifier(replyTitleCellIdentifier, forIndexPath: indexPath) as! ReplyTitleCell
                let postModel = newsModel.bbsInfo.posts[indexPath.row / 2]
                let viewModel = ReplyTitleCellViewModel(model: postModel)
                cell.configure(viewModel)
                cell.selectionStyle = .None
                return cell
            }else {
                return prepareCellForIndexPath(tableView, indexPath: indexPath)
            }

        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let type = DetailControllerCellType.analyseCellType(newsModel, indexPath: indexPath)
        
        switch type {
        case .NewsContent:
            return webView.frame.height
        case .DeviceNews:
            return 100
        case .Comment(let replyType):
            if replyType == .Title {
                return 60
            }else {
                let cell = prepareCellForIndexPath(tableView, indexPath: indexPath)
                return cell.requiredRowHeightInTableView(tableView)

            }
        }

    }
    
    
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
        guard section != 0 && newsModel.bbsInfo.posts.count >= 9 else {
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

// MARK: - HtmlContentCellDelegate
extension NewsDetailController: HtmlContentCellDelegate {
    func htmlContentCellSizeDidChange(cell: HtmlContentCell) {
        if let _ = tableView.indexPathForCell(cell) {
            tableView.reloadData()
        }
    }
    func htmlContentCell(cell: HtmlContentCell, linkDidPress link: NSURL) {
        jumpToOtherLinker(link.URLString)
    }
}
