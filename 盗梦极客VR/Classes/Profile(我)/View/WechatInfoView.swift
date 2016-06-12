//
//  WechatInfoView.swift
//  盗梦极客VR
//
//  Created by wl on 6/12/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class WechatInfoView: UIView {
    
    static let wechatInfoView = NSBundle.mainBundle().loadNibNamed("WechatInfoView", owner: nil, options: nil).first as! WechatInfoView

    override func awakeFromNib() {
        let windows = UIApplication.sharedApplication().keyWindow!
        frame = windows.bounds
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    static func show() {
        let view = WechatInfoView.wechatInfoView
        let windows = UIApplication.sharedApplication().keyWindow!
        windows.addSubview(view)
    }
    
    static func hidden() {
        WechatInfoView.wechatInfoView.removeFromSuperview()
    }
    
    func tap() {
        WechatInfoView.hidden()
    }
}
