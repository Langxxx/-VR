//
//  ContainerView.swift
//  盗梦极客VR
//
//  Created by wl on 4/25/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class ContainerView: UICollectionView {

    override func awakeFromNib() {
        initailContainerView()
    }
}

extension ContainerView {
    func initailContainerView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionViewLayout = layout
        pagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
}

extension UICollectionViewFlowLayout {
    override public func prepareLayout() {
        super.prepareLayout()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.contentInset = UIEdgeInsetsZero
        collectionView.contentOffset = CGPointZero
        itemSize = collectionView.bounds.size
    }
}