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
    
    var URL: String = ""
    
    var newsModelArray: [NewsModel] = [] {
        didSet {
            tableView.hidden = false
            tableView.reloadData()
        }
    }
    
    var topNewsModelArray: [NewsModel] = []
    
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
        
        fetchJsonFromNet(URL, parameters)
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
        
        fetchJsonFromNet(URL, parameters)
            .map { jsonToModelArray( $0["posts"], initial: NewsModel.init) }
            .complete(success: success, failure: failure)
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
        let vc = UIStoryboard(name: "News", bundle: nil).instantiateViewControllerWithIdentifier("NewsDetailController") as! NewsDetailController
        vc.newsModel = selectedCellModel
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
    }
}