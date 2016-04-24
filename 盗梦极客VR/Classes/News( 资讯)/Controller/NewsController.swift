//
//  NewsController.swift
//  盗梦极客VR
//
//  Created by wl on 4/24/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class NewsController: UIViewController {
    
    @IBOutlet weak var channelScrollView: ChannelScrollView!
    @IBOutlet weak var containerView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelScrollView.myDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NewsController: ChannelScrollViewDelegate {
    func channelScrollView(channelScrollView: ChannelScrollView, didClikChannelLabel: UILabel) {
        print("didClikChannelLabel")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollViewDidScroll")
    }
}

