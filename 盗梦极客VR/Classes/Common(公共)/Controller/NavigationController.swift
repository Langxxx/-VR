//
//  NavigationController.swift
//  盗梦极客VR
//
//  Created by wl on 6/7/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setNavigationBarHidden(hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(true, animated: animated)
    }
}
