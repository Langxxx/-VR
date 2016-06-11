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
        addRootNavController("News", title: "首页", iconName: "1", seletedIconName: "1")
//        addRootNavController("Evaluation", title: "评测", iconName: "")
        addRootNavController("BBS", title: "论坛", iconName: "2", seletedIconName: "2")
        addRootNavController("Profile", title: "我", iconName: "3", seletedIconName: "3")
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
    /**
     程序最开始由viewDidLoad调用
     用作设置一些展示样式(主题色)
     */
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
        
        tabBar.tintColor = UIColor.tintColor()
        tabBar.translucent = false
        
        let attr = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        navBar.titleTextAttributes = attr
    }
}

func dPrint(@autoclosure item: () -> Any) {
    #if DEBUG
        print(item())
    #endif
}
