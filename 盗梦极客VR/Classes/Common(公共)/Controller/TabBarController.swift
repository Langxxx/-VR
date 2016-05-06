//
//  TabBarController.swift
//  盗梦极客VR
//
//  Created by wl on 4/20/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupRootNavController()
    }

}

extension TabBarController {
    
    /**
     添加导航控制器
     */
    func setupRootNavController() {
        addRootNavController("News", title: "资讯", iconName: "tabbar_icon_news_normal", seletedIconName: "tabbar_icon_news_highlight")
//        addRootNavController("Evaluation", title: "评测", iconName: "")
        addRootNavController("BBS", title: "论坛", iconName: "tabbar_icon_BBS_normal", seletedIconName: "tabbar_icon_BBS_highlight")
        addRootNavController("Profile", title: "我", iconName: "tabbar_icon_profile_normal", seletedIconName: "tabbar_icon_profile_highlight")
    }
    
    /**
     在程序最开始运行自动调用
     为当前TabBarController初始化并添加一个控制器
     
     - parameter storyboardName: storyboard文件名
     - parameter identifier:     需要加载的控制器标识符
     - parameter title:          tabbarItem名称
     - parameter iconName:       图标
     */
    private func addRootNavController(storyboardName: String,
                                      identifier: String = "NavigationController",
                                      title: String,
                                      iconName: String,
                                      seletedIconName: String
        ) {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(identifier)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(named: iconName)
        vc.tabBarItem.selectedImage = UIImage(named: seletedIconName)
        addChildViewController(vc)
    }
    
    func setupStyle() {
        let tabBarItem = UITabBarItem.appearance()
        let selectedAttr = [
            NSForegroundColorAttributeName : UIColor.tintColor()
        ]
        
        tabBarItem.setTitleTextAttributes(selectedAttr, forState: .Selected)
        
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.whiteColor()
        navBar.barTintColor = UIColor.tintColor()
        navBar.translucent = false
        
        let attr = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        navBar.titleTextAttributes = attr
    }
}

extension UIColor {
    static func tintColor() -> UIColor {
        return UIColor(red: 212 / 255.0, green: 25 / 255.0, blue: 38 / 255.0, alpha: 1.0)
    }
}
