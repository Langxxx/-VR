//
//  StaticCell.swift
//  盗梦极客VR
//
//  Created by wl on 5/8/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class StaticCell: UITableViewCell {

    var item: BaseCellModel! {
        didSet {
            setupData()
            setUpAccessoryView()
        }
    }
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        label.textAlignment = .Right
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(13)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}

extension StaticCell {
    func setupData() {
        textLabel?.text = item.text
        if let icon = item.icon {
            imageView?.image = UIImage(named: icon)
        }
    }
    
    func setUpAccessoryView() {
        if item.isKindOfClass(RightDetallCellModel.self) {
            let model = item as! RightDetallCellModel
            rightLabel.text = model.rightDetall
            selectionStyle = .None
            accessoryView = rightLabel
        }
    }
}