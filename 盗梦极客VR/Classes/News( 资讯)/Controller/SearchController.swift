//
//  SearchController.swift
//  盗梦极客VR
//
//  Created by wl on 6/7/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchController: UIViewController, DetailVcJumpable {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    let searchController = UISearchController(searchResultsController: nil)
    
    var results: [NewsModel] = []

    var isFirstAppeal = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchVC()
        topView.backgroundColor = UIColor.tintColor()
        searchView.backgroundColor = UIColor.tintColor()
        tableView.delegate = self
        tableView.dataSource = self
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
         MobClick.beginLogPageView("搜索界面")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("搜索界面")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppeal {
            searchController.active = true
            // skipping to the next run loop is required, otherwise the keyboard does not appear
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                self?.searchController.searchBar.becomeFirstResponder()
                })
            isFirstAppeal = false
        }
    }

    deinit {
        dPrint("SearchController deinit")
    }
}

extension SearchController {
    func setupSearchVC() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchView.addSubview(searchController.searchBar)
        searchController.searchBar.placeholder = "请输入关键字"
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.tintColor()
        searchController.searchBar.tintColor = UIColor.whiteColor()
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchStr =  searchBar.text where !searchStr.isEmpty else {
            return
        }
        
        func success(modelArray: [NewsModel]) {
            results = modelArray
            activityView.hidden = true
            tableView.hidden = false
            tableView.reloadData()
            if modelArray.count == 0 {
                MBProgressHUD.showWarning("没有相关信息!")
            }
        }
        func failure(_: ErrorType) {
            MBProgressHUD.showError("网络异常，请稍后尝试!")
            tableView.hidden = true
            activityView.hidden = true
        }
        
        activityView.hidden = false
        tableView.hidden = true
        let url = "http://dmgeek.com/DG_api/get_search_results/?search=\(searchStr)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        fetchJsonFromNet(url)
            .map{ jsonToModelArray($0["posts"], initial: NewsModel.init) }
            .complete(success: success, failure: failure)
    }
}

extension SearchController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)
        let newsModel = results[indexPath.row]
        cell.textLabel?.text = newsModel.title
        return cell
    }
}

extension SearchController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let newsModel = results[indexPath.row]
        pushDetailVcBySelectedNewsModel(newsModel)
    }
}