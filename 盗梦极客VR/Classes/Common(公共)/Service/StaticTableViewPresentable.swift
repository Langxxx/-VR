//
//  StaticTableViewPresentable.swift
//  盗梦极客VR
//
//  Created by wl on 5/8/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

protocol StaticTableViewPresentable: UITableViewDataSource {
    // TODO: 随便取的
    associatedtype ModelArray
    var dataList: [ModelArray]  {get}
    
    weak var tableView: UITableView! {get}
}


extension StaticTableViewPresentable {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataList.count
    }
}