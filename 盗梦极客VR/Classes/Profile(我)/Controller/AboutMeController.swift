//
//  AboutMeController.swift
//  盗梦极客VR
//
//  Created by wl on 6/12/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class AboutMeController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    
    deinit {
        dPrint("AboutMeController deinit")
    }

}


extension AboutMeController {
    @IBAction func backButtonClik() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func jumptoWebButtonClik() {
        let url = NSURL(string: "http://dmgeek.com/")!
        UIApplication.sharedApplication().openURL(url)
    }
    @IBAction func followSinaButtonClik() {
        let url = NSURL(string: "http://weibo.com/dmgeek?is_hot=1")!
        UIApplication.sharedApplication().openURL(url)
    }
    @IBAction func followWechatButtonClik() {
        WechatInfoView.show()
    }
    
}
