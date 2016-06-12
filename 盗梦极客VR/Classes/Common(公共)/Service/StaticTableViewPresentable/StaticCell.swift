//
//  StaticCell.swift
//  盗梦极客VR
//
//  Created by wl on 5/8/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import SnapKit

class StaticCell: UITableViewCell {

    var item: BaseCellModel! {
        didSet {
            setupData()
            setUpAccessoryView()
        }
    }

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
        if item.isKindOfClass(RightDetallWithArrowCellModel.self) {
            let model = item as! RightDetallWithArrowCellModel
            selectionStyle = .Default
            accessoryView = getRightTextWithArrowView(model.rightDetall)
        }else if item.isKindOfClass(RightDetallCellModel.self) {
            let model = item as! RightDetallCellModel
            selectionStyle = .None
            accessoryView = getDetailLabel(model.rightDetall)
        }else if item.isKindOfClass(ArrowCellModel.self) {
            selectionStyle = .Default
            accessoryView = getArrowView()
        }
    }
}

private extension StaticCell {
   func getDetailLabel(detail: String) -> UILabel {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        label.textAlignment = .Right
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(13)
        label.text = detail
        return label
    }
    
    func getArrowView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        let arrowImageView = UIImageView()
        arrowImageView.frame = CGRect(x: view.frame.width - 16, y: 4, width: 35, height: 35)
        arrowImageView.image = UIImage(named: "cellarrow")
        view.addSubview(arrowImageView)
        return view
    }
    
    func getRightTextWithArrowView(rightText: String) -> UIView {
        
        let view = getArrowView()
        
        let label = getDetailLabel(rightText)
        label.frame = CGRect(x: 0, y: 0, width: view.frame.width - 10, height: 44)
        view.addSubview(label)
        
        return view
    }
    
}