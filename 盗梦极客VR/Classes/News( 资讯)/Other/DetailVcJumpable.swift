//
//  DetailVcJumpable.swift
//  盗梦极客VR
//
//  Created by wl on 6/7/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

protocol DetailVcJumpable {
    /**
     跳转到新闻详情页面
     在点击某一个新闻后调用
     
     - parameter selectedCellModel: 被点击新闻的模型
     */
    func pushDetailVcBySelectedNewsModel(selectedCellModel: NewsModel)
}

extension DetailVcJumpable where Self: UIViewController {
    /**
     跳转到新闻详情页面
     在点击某一个新闻后调用
     
     - parameter selectedCellModel: 被点击新闻的模型
     */
    func pushDetailVcBySelectedNewsModel(selectedCellModel: NewsModel) {
//        let vc = UIStoryboard(name: "News", bundle: nil).instantiateViewControllerWithIdentifier("NewsDetailController") as! NewsDetailController
//        vc.newsModel = selectedCellModel
//        vc.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(vc, animated: true)
//        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
//            interactivePopGestureRecognizer.delegate = nil
//        }
        
        let vc = UIStoryboard(name: "News", bundle: nil).instantiateViewControllerWithIdentifier("TestViewController") as! TestViewController
        vc.newsModel = selectedCellModel
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            interactivePopGestureRecognizer.delegate = nil
        }
    }

}

