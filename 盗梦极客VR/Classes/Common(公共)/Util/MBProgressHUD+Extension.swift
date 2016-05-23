//
//  MBProgressHUD+Extension.swift
//  盗梦极客VR
//
//  Created by wl on 4/27/16.
//  Copyright © 2016 wl. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {
    static func show(text: String, icon: String, view: UIView) {

        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        hud.label.text = text
        
        hud.customView = UIImageView(image: UIImage(named: icon))
        hud.mode = .CustomView
        
        hud.removeFromSuperViewOnHide = true
        hud.hideAnimated(true, afterDelay: 1.5)
    }

    static func showSuccess(text: String, toView: UIView = UIApplication.sharedApplication().keyWindow!) {
        MBProgressHUD.hideHUD(toView)
        MBProgressHUD.show(text, icon: "success", view: toView)
    }
    
    static func showError(text: String, toView: UIView = UIApplication.sharedApplication().keyWindow!) {
        MBProgressHUD.hideHUD(toView)
        MBProgressHUD.show(text, icon: "error", view: toView)
    }
    
    static func showMessage(text: String, toView: UIView = UIApplication.sharedApplication().keyWindow!) {
        MBProgressHUD.hideHUD(toView)
        let hud = MBProgressHUD.showHUDAddedTo(toView, animated: true)
        hud.detailsLabel.text = text
        hud.removeFromSuperViewOnHide = true
    }
    
    static func hideHUD(toView: UIView = UIApplication.sharedApplication().keyWindow!) {
        MBProgressHUD.hideHUDForView(toView, animated: true)
    }
}
