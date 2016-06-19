//
//  ContainerController.swift
//  盗梦极客VR
//
//  Created by wl on 4/24/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
        /// 显示频道标签的view
    @IBOutlet weak var channelScrollView: ChannelScrollView!
        /// 容纳显示列表的view
    @IBOutlet weak var containerView: ContainerView!

    @IBOutlet weak var searchButton: UIButton!
    
        /// collectionView的数据源
    var collectionViewCellProvider: ContainerViewDataSource!
        /// 频道的model数组
    var channelModelArray: [ChannelModel]!
        /// 当前控制器被选中的标识
    var isSeletedVc = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChannelScrollView()
        setupChildViewControllers()
        setupContainerView()
        tabBarController?.delegate = self
        searchButton.backgroundColor = UIColor.tintColor().colorWithAlphaComponent(0.7)

        checkAppVersion()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension ContainerController {
    
    func checkAppVersion() {
        
        if arc4random_uniform(5) != 0 { return }
        
        let currentVersion = NSBundle.currentVersion
        func success(version: String) {
            if currentVersion == version {
            }else {
                let alert = UIAlertController(title: "更新", message: "是否进行更新?", preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "取消",
                                           style: .Default) { _ in
                }
                let reTry = UIAlertAction(title: "更新",
                                          style: .Default) { _ in
                                            let url = NSURL(string: "itms-apps://itunes.apple.com/cn/app/dao-meng-ji-kevr/id1118642139?mt=8")!
                                            UIApplication.sharedApplication().openURL(url)
                }
                alert.addAction(cancel)
                alert.addAction(reTry)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        func failure(_: ErrorType) {
        }
        
        latestAPPVersion(success, failure: failure)
    }
}

// MARK: - 一些初始化方法
extension ContainerController {
    /**
     设置频道标签的一些内容
     */
    func setupChannelScrollView() {
        
        channelScrollView.myDelegate = self
        channelModelArray = ChannelModel.getChannelModels()
        channelScrollView.channles = channelModelArray.map { $0.title }
        channelScrollView.backgroundColor = UIColor.tintColor()
        channelScrollView.bounces = true
    }
    
    /**
     设置所有子控制器
     */
    func setupChildViewControllers() {
        let sb = UIStoryboard(name: "News", bundle: nil)
        for i in 0..<channelScrollView.channles.count {
            let vc = sb.instantiateViewControllerWithIdentifier("NewsListController") as! NewsListController
            vc.channelModel = self.channelModelArray[i]
            addChildViewController(vc)
        }
    }
    /**
      设置collectionView cell的显示内容
     */
    func setupContainerView() {
        
        collectionViewCellProvider = ContainerViewDataSource(items: channelScrollView.channles, cellIdentifier: "Cell") { cell, item, indexPath in
            // 移除之前的子控件
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            let vc = self.childViewControllers[indexPath.row] as! NewsListController
            cell.contentView.addSubview(vc.view)
            
            vc.view.snp_remakeConstraints { (make) in
                make.top.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView)
                make.right.equalTo(cell.contentView)
                make.left.equalTo(cell.contentView)
            }
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
        let indexpath = NSIndexPath(forRow: channelLabel.tag, inSection: 0)
        containerView.scrollToItemAtIndexPath(indexpath, atScrollPosition: .None, animated: false)
    }

}

extension ContainerController: UITabBarControllerDelegate {
    /**
     用来回滚到列表顶部
     UITabBarController被点击时调用
     
     - parameter tabBarController: <#tabBarController description#>
     - parameter viewController:   <#viewController description#>
     */
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        guard let navVC = viewController as? UINavigationController else {
            return
        }
        if navVC.topViewController!.isKindOfClass(ContainerController.self) {
            if  isSeletedVc {
                let cellIndexPath = containerView.indexPathForCell(containerView.visibleCells().first!)!
                let vc = childViewControllers[cellIndexPath.row] as! NewsListController
                vc.tableView.setContentOffset(CGPointZero, animated:true)
            }
            isSeletedVc = true
        }else {
            isSeletedVc = false
        }
    }
}
