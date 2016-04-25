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
    @IBOutlet weak var containerView: UICollectionView!
    
    var currentChannelIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelScrollView.myDelegate = self
        setupContainerView()
        setupChildViewControllers()
    }

    func setupContainerView() {
        
        containerView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        containerView.collectionViewLayout = layout
        containerView.pagingEnabled = true
        containerView.showsVerticalScrollIndicator = false
        containerView.showsHorizontalScrollIndicator = false
        containerView.dataSource = self
    }
    
    func setupChildViewControllers() {
        let sb = UIStoryboard(name: "News", bundle: nil)
        for _ in 0..<channelScrollView.channles.count {
            let vc = sb.instantiateViewControllerWithIdentifier("NewsListController")
            addChildViewController(vc)
        }
    }
}

extension UICollectionViewFlowLayout {
    override public func prepareLayout() {
        super.prepareLayout()
        guard let collectionView = collectionView else {
            return
        }
//        minimumInteritemSpacing = 0
//        minimumLineSpacing = 0
        collectionView.contentInset = UIEdgeInsetsZero
        collectionView.contentOffset = CGPointZero
        itemSize = collectionView.bounds.size
    }
}

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

extension ContainerController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        let vc = childViewControllers[indexPath.row] as! NewsListController
        vc.view.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        vc.cellTest = channelScrollView.channles[indexPath.row]
        cell.contentView.addSubview(vc.view)
        
        cell.backgroundColor = UIColor.grayColor()
        return cell
    }
}

extension ContainerController: ChannelScrollViewDelegate {
    
    func channelScrollView(channelScrollView: ChannelScrollView, didClikChannelLabel channelLabel: UILabel) {
         print("didClikChannelLabel")
        let indexpath = NSIndexPath(forRow: channelLabel.tag, inSection: 0)
        containerView.scrollToItemAtIndexPath(indexpath, atScrollPosition: .None, animated: false)
    }

}

