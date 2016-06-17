//
//  DetailControllerCellType.swift
//  盗梦极客VR
//
//  Created by wl on 6/17/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

enum DetailControllerCellType {
    case NewsContent
    case Comment(Reply)
    case DeviceNews
    
    static func analyseCellType(newsModel: NewsModel, indexPath: NSIndexPath) -> DetailControllerCellType {
        if indexPath.section == 0 {
            return .NewsContent
        }else if newsModel.type == "device" {
            return .DeviceNews
        }else {
            if indexPath.row % 2 == 0 {
                return .Comment(.Title)
            }else {
                return .Comment(.Content)
            }
        }
    }
}

enum Reply {
    case Title
    case Content
}