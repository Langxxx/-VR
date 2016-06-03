//
//  ChannelLabel.swift
//  盗梦极客VR
//
//  Created by wl on 4/24/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class ChannelLabel: UILabel {

    let gray: CGFloat = 109
    
    var scale: CGFloat = 0.0 {
        didSet {
//            let redColor = (146 * scale + 109) / 255
//            let otherColor = gray * (1 - scale) / 255
            
//            self.textColor = UIColor(red: redColor, green: otherColor, blue: otherColor, alpha: 1)
            self.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5 + 0.5 * scale)
            let s: CGFloat = 1 + scale * CGFloat(0.3)
            self.transform = CGAffineTransformMakeScale(s, s)
        }
    }

}
