//
//  ContainerController.swift
//  盗梦极客VR
//
//  Created by wl on 4/24/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    @IBOutlet weak var channelScrollView: ChannelScrollView!
    @IBOutlet weak var containerView: ContainerView!
    
    var collectionViewCellProvider: ContainerViewDataSource!
    
    var channelModelArray: [ChannelModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChannelScrollView()
        setupChildViewControllers()
        setupContainerView()
        
    }
    
    func setupChannelScrollView() {
        
        channelScrollView.myDelegate = self
        channelModelArray = ChannelModel.getChannelModels()
        channelScrollView.channles = channelModelArray.map { $0.title }
    }
    
    func setupChildViewControllers() {
        let sb = UIStoryboard(name: "News", bundle: nil)
        for _ in 0..<channelScrollView.channles.count {
            let vc = sb.instantiateViewControllerWithIdentifier("NewsListController")
            addChildViewController(vc)
        }
    }
    
    func setupContainerView() {
        
        collectionViewCellProvider = ContainerViewDataSource(items: channelScrollView.channles, cellIdentifier: "Cell") { cell, item, indexPath in
            // 移除之前的子控件
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            let vc = self.childViewControllers[indexPath.row] as! NewsListController
            vc.view.frame = CGRect(x: 0, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
            vc.type = self.channelModelArray[indexPath.row].URL
                
            cell.contentView.addSubview(vc.view)
        }
        
        containerView.dataSource = collectionViewCellProvider
        containerView.delegate = self
    }
}



// MARK: - UICollectionViewDelegate 代理
extension ContainerController: UICollectionViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentIndex = scrollView.contentOffset.x / scrollView.bounds.width
        let leftIndex = Int(currentIndex)
        let rightIndex = leftIndex + 1
        
        guard currentIndex > 0 && rightIndex <  channelScrollView.labelArray.count else {
            return
        }
        let rightScale = currentIndex - CGFloat(leftIndex)
        let leftScale = CGFloat(rightIndex) - currentIndex
        
        let rightLabel = channelScrollView.labelArray[rightIndex]
        let leftLabel = channelScrollView.labelArray[leftIndex]
        
        rightLabel.scale = rightScale
        leftLabel.scale = leftScale
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        channelScrollView.currentChannelIndex = index
    }

}

// MARK: - ChannelScrollViewDelegate 代理
extension ContainerController: ChannelScrollViewDelegate {
    
    func channelScrollView(channelScrollView: ChannelScrollView, didClikChannelLabel channelLabel: UILabel) {
         print("didClikChannelLabel")
        let indexpath = NSIndexPath(forRow: channelLabel.tag, inSection: 0)
        containerView.scrollToItemAtIndexPath(indexpath, atScrollPosition: .None, animated: false)
    }

}

