//
//  TaxonomyScrollView.swift
//  盗梦极客VR
//
//  Created by wl on 6/1/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

protocol TaxonomyScrollViewDelegate: class {
    func taxonomyScrollView(taxonomyScrollView: TaxonomyScrollView, didSeletedTaxonomy taxonomy: Taxonomy)
}

class TaxonomyScrollView: UIScrollView {

    var taxonomies: [Taxonomy]! {
        didSet {
            setupTaxonomyButton()
        }
    }
    
    weak var taxonomyDelegate: TaxonomyScrollViewDelegate?
    
    /// 标签之间的间距
    let buttonMargin: CGFloat = 25
    /// 所有频道标签
    var buttonArray: [UIButton] = []
    
}

extension TaxonomyScrollView {

    func setupTaxonomyButton() {
        
        guard taxonomies.count != 0 else {
            return
        }
        
        let windowsW = UIApplication.sharedApplication().keyWindow!.frame.width
        var totalWidth: CGFloat = 0
        
        for (index, taxonomy) in taxonomies.enumerate() {
            let btn = UIButton()
            
            btn.titleLabel?.textAlignment = .Center
            btn.setTitle(taxonomy.title, forState: .Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(13)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
            btn.setBackgroundImage(UIImage(named: "concerned_border"), forState: .Normal)
            btn.sizeToFit()
            btn.frame.size.width = btn.frame.size.width + 20
            totalWidth += btn.frame.size.width
            
            btn.tag = index
            btn.addTarget(self, action: #selector(btnClik(_:)), forControlEvents: .TouchUpInside)
            buttonArray.append(btn)
            addSubview(btn)
        }

        func getButtonX(index: Int) -> CGFloat {
           if index == 0 {
                return buttonMargin
            }
            return CGRectGetMaxX(buttonArray[index - 1].frame) + buttonMargin
        }
        
        
        for (index, btn) in buttonArray.enumerate() {
            btn.frame.origin.y = (bounds.height -  btn.bounds.height) * 0.5
            btn.frame.origin.x = getButtonX(index)
        }
        
        contentSize = CGSize(width: getButtonX(buttonArray.count), height: 0)
    }
}

extension TaxonomyScrollView {
    func btnClik(btn: UIButton) {
        let seletedModel = taxonomies[btn.tag]
        taxonomyDelegate?.taxonomyScrollView(self, didSeletedTaxonomy: seletedModel)
    }
}