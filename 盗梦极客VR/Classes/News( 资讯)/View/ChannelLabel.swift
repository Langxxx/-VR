//
//  ChannelLabel.swift
//  盗梦极客VR
//
//  Created by wl on 4/24/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class ChannelLabel: UILabel {

    var scale: CGFloat = 0.0 {
        didSet {
            self.textColor = UIColor(red: scale, green: 0, blue: 0, alpha: 1)
            let s: CGFloat = 1 + scale * CGFloat(0.3)
            self.transform = CGAffineTransformMakeScale(s, s)
        }
    }

}
