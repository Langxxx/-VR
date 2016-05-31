//
//  ContainerViewDataSource.swift
//  盗梦极客VR
//
//  Created by wl on 4/25/16.
//  Copyright © 2016 wl. All rights reserved.
//  UICollectionView的数据源

import UIKit

class ContainerViewDataSource: NSObject {
    // TODO: swift2.0中无法给让遵守UICollectionViewDataSource协议的类使用泛型
    var items: [AnyObject]

    let cellIdentifier: String
    
    let configureCell: (UICollectionViewCell, AnyObject, NSIndexPath) -> ()
    
    init(items: [AnyObject], cellIdentifier: String,
         configureCell: (UICollectionViewCell, AnyObject, NSIndexPath) -> ()
        ) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
    }
}

extension ContainerViewDataSource {
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return items[indexPath.row]
    }
}

extension ContainerViewDataSource: UICollectionViewDataSource {
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        let item = itemAtIndexPath(indexPath)
        configureCell(cell, item, indexPath)
        
        return cell
    }
}