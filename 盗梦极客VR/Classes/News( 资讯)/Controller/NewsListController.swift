//
//  NewsListController.swift
//  盗梦极客VR
//
//  Created by wl on 4/24/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewsListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var URL: String = ""
    
    var newsModelArray: [NewsModel]? {
        didSet {
            print(newsModelArray)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        fetchJsonFromNet(URL)
            .map { jsonToModelArray( $0["posts"], initial: NewsModel.init) }
            .operation { result in
                switch result {
                case .Success(let v):
                    self.newsModelArray = v
                case .Failure(_):
                    SVProgressHUD.showErrorWithStatus("网络异常，请稍后尝试")
                }
            }
    }

    
}

extension NewsListController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("test", forIndexPath: indexPath)
        cell.textLabel?.text = URL
        return cell
    }
}