//
//  CellModel.swift
//  盗梦极客VR
//
//  Created by wl on 5/8/16.
//  Copyright © 2016 wl. All rights reserved.
//

import Foundation

struct CellGroup {
    
    let header: String?
    var items: [BaseCellModel]
    let footer: String?
    
    init(header: String? = nil, items: [BaseCellModel], footer: String? = nil) {
        self.header = header
        self.items = items
        self.footer = footer
    }
}


class BaseCellModel: NSObject {
    let text: String
    let icon: String?
    
    var seletedCallBack: (() -> ())?
    
    init(text: String, icon: String? = nil, seletedCallBack: (() -> ())? = nil) {
        self.text = text
        self.icon = icon
        self.seletedCallBack = seletedCallBack
    }
}


class RightDetallCellModel: BaseCellModel {
    var rightDetall: String
    
    init(text: String, rightDetall: String, icon: String? = nil, seletedCallBack: (() -> ())? = nil) {
        self.rightDetall = rightDetall
        super.init(text: text, icon: icon, seletedCallBack: seletedCallBack)
    }
}

class RightDetallWithArrowCellModel: RightDetallCellModel {
    
}
