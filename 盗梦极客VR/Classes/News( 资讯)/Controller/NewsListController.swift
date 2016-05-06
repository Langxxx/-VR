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

class NewsListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadLabel: UILabel!
    
    var channelModel: ChannelModel!
    
    var newsModelArray: [NewsModel] = [] {
        didSet {
            tableView.hidden = false
            tableView.reloadData()
        }
    }
    
    var topNewsModelArray: [NewsModel] = [] {
        didSet {
            if channelModel.title == "资讯" {
                setupTableHeardView()
            }
        }
    }
    
    var parameters: [String: AnyObject] {
        return [
            "page": newsModelArray.count / 10 + 1
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadNetworkData()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        loadNetworkData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension NewsListController {
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.hidden = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreNews))
    }
    
    func setupTableHeardView() {
        let headerView = CyclePictureView(frame: CGRectZero, imageURLArray: nil)
        headerView.imageURLArray = topNewsModelArray.map { $0.listThuUrl }
        headerView.imageDetailArray = topNewsModelArray.map { $0.title }
        headerView.detailLableBackgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        headerView.autoScroll = false
        headerView.pageControlAliment = .RightBottom
        headerView.currentDotColor = UIColor.tintColor()
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = headerView.frame.size.width * 0.7
    }
    
    func loadNetworkData() {
        
        self.reloadLabel.hidden = true
        MBProgressHUD.showMessage("正在玩命加载", toView: view)

        func success(modelArray: [[NewsModel]]) {
            MBProgressHUD.hideHUD(self.view)
            self.newsModelArray += modelArray[0]
            self.topNewsModelArray = modelArray[1]
        }
        
        func failure(_: ErrorType) {
            MBProgressHUD.hideHUD(self.view)
            MBProgressHUD.showError("网络异常，请稍后尝试")
            self.reloadLabel.hidden = false
        }
        // TODO: 如果是非资讯分类，不应该fetchTopNewsJsonFromNet
        fetchJsonFromNet(channelModel.URL, parameters)
            .then(fetchTopNewsJsonFromNet)
            .map { jsonToModelArray( $0, initial: NewsModel.init) }
            .complete(success: success, failure: failure)
    }
    
    func loadMoreNews() {
        
        func success(modelArray: [NewsModel]) {
            MBProgressHUD.hideHUD(self.view)
            self.newsModelArray += modelArray
        }
        
        func failure(_: ErrorType) {
            MBProgressHUD.hideHUD(self.view)
            MBProgressHUD.showError("网络异常，请稍后尝试")
        }
        
        fetchJsonFromNet(channelModel.URL, parameters)
            .map { jsonToModelArray( $0["posts"], initial: NewsModel.init) }
            .complete(success: success, failure: failure)
    }

}

extension NewsListController {
    func pushDetailVcBySelectedNewsModel(selectedCellModel: NewsModel) {
        let vc = UIStoryboard(name: "News", bundle: nil).instantiateViewControllerWithIdentifier("NewsDetailController") as! NewsDetailController
        vc.newsModel = selectedCellModel
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
    }
}

extension NewsListController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModelArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCell
        let model = newsModelArray[indexPath.row]
        cell.configure(NewsCellViewModel(model: model))
        return cell
    }
}

extension NewsListController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedCellModel = newsModelArray[indexPath.row]
        pushDetailVcBySelectedNewsModel(selectedCellModel)
    }
}

extension NewsListController: CyclePictureViewDelegate {
    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCellModel = topNewsModelArray[indexPath.row]
        pushDetailVcBySelectedNewsModel(selectedCellModel)
    }
}