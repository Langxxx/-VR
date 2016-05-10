//
//  StaticTableViewPresentable.swift
//  盗梦极客VR
//
//  Created by wl on 5/8/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class TableViewProvider: NSObject {
    var dataList: [CellGroup]
    
    let cellID = "StaticCell"
    
    override init() {
        dataList = []
        super.init()
    }
    
    init(dataList: [CellGroup]) {
        self.dataList = dataList
    }
}

extension TableViewProvider: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! StaticCell
        
        cell.item = dataList[indexPath.section].items[indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataList[section].header
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataList[section].footer
    }
}

extension TableViewProvider: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cellModel = dataList[indexPath.section].items[indexPath.row]
        cellModel.seletedCallBack?()
    }
}
