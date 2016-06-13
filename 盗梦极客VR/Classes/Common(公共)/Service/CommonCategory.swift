//
//  Category.swift
//  盗梦极客VR
//
//  Created by wl on 6/11/16.
//  Copyright © 2016 wl. All rights reserved.
//  一些公共的扩展

import Foundation

extension UIColor {
    static func tintColor() -> UIColor {
        return UIColor(red: 212 / 255.0, green: 25 / 255.0, blue: 38 / 255.0, alpha: 1.0)
    }
}

extension String {
    func encodeURLString() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
}

extension NSBundle {
    static var currentVersion: String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    }
}