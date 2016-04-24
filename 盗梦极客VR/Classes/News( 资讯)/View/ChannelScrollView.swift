//
//  ChannelScrollView.swift
//  盗梦极客VR
//
//  Created by wl on 4/24/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

protocol ChannelScrollViewDelegate: UIScrollViewDelegate {
    func channelScrollView(channelScrollView: ChannelScrollView, didClikChannelLabel: UILabel)
}

class ChannelScrollView: UIScrollView {
    
    let channles = ["资讯","评测","设备","视频", "活动","评测","设备","视频", "活动"]

    let labelMargin: CGFloat = 25
    
    var labelArray: [UILabel] = []

    weak var myDelegate: ChannelScrollViewDelegate? {
        didSet {
            delegate = myDelegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupChannelLabel()
    }

}

extension ChannelScrollView {
    
    func setupChannelLabel() {
        func getLabelX() -> CGFloat {
            guard let lastLabel = labelArray.last else {
                return labelMargin
            }
            return CGRectGetMaxX(lastLabel.frame) + labelMargin
        }

        for (idx, title) in channles.enumerate() {
            // 初始化
            let label = UILabel()
            label.text = title
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize(17)
            label.sizeToFit()
            label.frame.origin.y = (bounds.height -  label.bounds.height) * 0.5
            label.frame.origin.x = getLabelX()
            
            //增加点击事件
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChannelScrollView.channelLabelClick(_:))))
            label.userInteractionEnabled = true
            label.tag = idx
            
            labelArray.append(label)
            self.addSubview(label)
        }
        contentSize = CGSize(width: getLabelX(), height: 0)
    }
    
    /**
     频道label的点击手势回调方法，
     当点击事件发生后，将新闻列表切换到被点击label对应的新闻列表
     */
    func channelLabelClick(recognizer: UITapGestureRecognizer) {
        let label = recognizer.view as! UILabel
        myDelegate?.channelScrollView(self, didClikChannelLabel: label)
    }

}
