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
        let layout = ContainerViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionViewLayout = layout
        pagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        scrollsToTop = false
    }
}

class ContainerViewFlowLayout: UICollectionViewFlowLayout {
    override internal func prepareLayout() {
        super.prepareLayout()
        guard let collectionView = collectionView else {
            return
        }
        collectionView.contentInset = UIEdgeInsetsZero
        itemSize = collectionView.bounds.size
    }
}
