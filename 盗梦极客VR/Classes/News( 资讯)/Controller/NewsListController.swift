//
//  NewsListController.swift
//  盗梦极客VR
//
//  Created by wl on 4/24/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class NewsListController: UIViewController, DetailVcJumpable {

    @IBOutlet weak var tableView: UITableView!
        /// tableView距离顶部的距离约束
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
        /// 重新加载的提示label
    @IBOutlet weak var reloadLabel: UILabel!
        /// 当前频道的模型
    var channelModel: ChannelModel!
        /// 新闻模型数组
    var newsModelArray: [NewsModel] = [] {
        didSet {
            tableView.hidden = false
            tableView.reloadData()
            page += 1
        }
    }
        /// 资讯列表头部轮播新闻数组
    var topNewsModelArray: [NewsModel] = [] {
        didSet {
            if channelModel.taxonomies.count != 0 {
                setupTableHeardView()
            }
        }
    }
        /// 请求参数
    var parameters: [String: AnyObject] {
        return [
            "page": page
        ]
    }
        /// 当前请求的页数
    var page = 1
    
        /// 分类模型
    var taxonomy: Taxonomy?
    
    @IBOutlet weak var taxonomyLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    
    var requstURL: String {
        if let taxonomy = taxonomy {
            return "http://dmgeek.com/DG_api/get_taxonomy_posts/?taxonomy=\(channelModel.type)&id=\(taxonomy.id)"
        }else {
            return channelModel.URL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadNetworkData()
        if let taxonomy = taxonomy {
            topView.hidden = false
            tableViewTopConstraint.constant = topView.bounds.height - 20
            taxonomyLabel.text = taxonomy.title
        }
    }
    
        /// 分类视图的高度
    let taxonomyScrollViewH: CGFloat = 30
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !reloadLabel.hidden {
            loadNetworkData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.scrollsToTop = true
        
        MobClick.beginLogPageView(channelModel.title)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.scrollsToTop = false
        
        MobClick.endLogPageView(channelModel.title)
    }
}

// MARK: - 初始化方法
extension NewsListController {
    /**
     设置tabView
     */
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.hidden = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreNews))
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNetworkData))
    }
    /**
     设置顶部轮播视图、和分类
     */
    func setupTableHeardView() {
        guard taxonomy == nil else {
            return
        }
        
        let heardView = UIView()
        tableView.tableHeaderView = heardView
        let heardViewW = heardView.bounds.width
        
        let taxonomyScrollView = TaxonomyScrollView(frame: CGRectZero)
        heardView.addSubview(taxonomyScrollView)
        taxonomyScrollView.frame.origin = CGPointZero
        taxonomyScrollView.frame.size = CGSize(width: heardViewW, height: taxonomyScrollViewH)
        taxonomyScrollView.showsHorizontalScrollIndicator = false
        taxonomyScrollView.taxonomies = channelModel.taxonomies
        taxonomyScrollView.taxonomyDelegate = self
        tableView.tableHeaderView?.bounds.size.height = CGRectGetMaxY(taxonomyScrollView.frame)
        
        let splitView = UIView()
        splitView.frame = CGRect(x: 0, y: CGRectGetMaxY(taxonomyScrollView.frame) - 1, width: heardViewW, height: 1)
        splitView.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 223/255.0, alpha: 1)
        heardView.addSubview(splitView)
        
        if channelModel.title == "资讯" {
            
            let cyclePictureView = CyclePictureView(frame: CGRectZero, imageURLArray: nil)
            cyclePictureView.imageURLArray = topNewsModelArray.map { $0.listThuUrl }
            cyclePictureView.imageDetailArray = topNewsModelArray.map { $0.title }
            cyclePictureView.detailLableBackgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            cyclePictureView.autoScroll = false
            cyclePictureView.pageControlAliment = .RightBottom
            cyclePictureView.currentDotColor = UIColor.tintColor()
            cyclePictureView.delegate = self
            cyclePictureView.placeholderImage = UIImage(named: "placeholderImage")
            heardView.addSubview(cyclePictureView)
            cyclePictureView.frame.origin = CGPoint(x: 0, y: taxonomyScrollViewH)
            cyclePictureView.frame.size = CGSize(width: heardViewW, height: heardViewW * 0.7)
            tableView.tableHeaderView?.bounds.size.height = CGRectGetMaxY(cyclePictureView.frame)
        }
        // 默认不显示分类
        tableView.setContentOffset(CGPoint(x: 0, y: taxonomyScrollViewH), animated: false)
        tableView.reloadData()

    }
}

// MARK: - 功能方法
extension NewsListController {
    /**
     加载最新新闻数据
     */
    func loadNetworkData() {
        
        self.reloadLabel.hidden = true
        //        MBProgressHUD.showMessage("正在玩命加载", toView: view)
        
        func success(modelArray: [[NewsModel]]) {
            tableView.mj_header.endRefreshing()
            page = 1
            self.newsModelArray = modelArray[0]
            self.topNewsModelArray = modelArray[1]
        }
        
        func failure(_: ErrorType) {
            tableView.mj_header.endRefreshing()
            MBProgressHUD.showError("网络异常，请稍后尝试")
            self.reloadLabel.hidden = false
            self.activityView.hidden = true
        }
        // TODO: 如果是非资讯分类，不应该fetchTopNewsJsonFromNet
        fetchJsonFromNet(requstURL, ["page": 1])
            .then(fetchTopNewsJsonFromNet)
            .map { jsonToModelArray( $0, initial: NewsModel.init) }
            .complete(success: success, failure: failure)
    }
    
    /**
     加载更多新闻数据
     */
    func loadMoreNews() {
        
        func success(modelArray: [NewsModel]) {
            tableView.mj_footer.endRefreshing()
            if modelArray.count == 0 {
                MBProgressHUD.showWarning("没有更多数据!")
            }else {
                self.newsModelArray += modelArray
            }
        }
        
        func failure(_: ErrorType) {
            MBProgressHUD.showError("网络异常，请稍后尝试")
            tableView.mj_footer.endRefreshing()
        }
        
        fetchJsonFromNet(requstURL, parameters)
            .map { jsonToModelArray( $0["posts"], initial: NewsModel.init) }
            .complete(success: success, failure: failure)
    }
}

// MARK: - 监听方法
extension NewsListController {
    @IBAction func backButtonClik() {
        navigationController?.popViewControllerAnimated(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NewsListController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModelArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCell
        let model = newsModelArray[indexPath.row]
        if channelModel.title == "设备" || channelModel.title == "视频" {
            cell.replyCountLabel.hidden = true
            cell.tagLabel.hidden = false
        }else {
            cell.replyCountLabel.hidden = false
            cell.tagLabel.hidden = true
            if channelModel.title == "活动" {
                model.date = "开始时间：" + model.date
            }
        }
        cell.configure(NewsCellViewModel(model: model))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsListController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedCellModel = newsModelArray[indexPath.row]
        pushDetailVcBySelectedNewsModel(selectedCellModel)
    }
}

// MARK: - CyclePictureViewDelegate
extension NewsListController: CyclePictureViewDelegate {
    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCellModel = topNewsModelArray[indexPath.row]
        pushDetailVcBySelectedNewsModel(selectedCellModel)
    }
}
// MARK: - TaxonomyScrollViewDelegate
extension NewsListController: TaxonomyScrollViewDelegate {
    func taxonomyScrollView(taxonomyScrollView: TaxonomyScrollView, didSeletedTaxonomy taxonomy: Taxonomy) {
        let vc = UIStoryboard(name: "News", bundle: nil).instantiateViewControllerWithIdentifier("NewsListController") as! NewsListController
        vc.channelModel = channelModel
        vc.taxonomy = taxonomy
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}