//
//  SVProgressHUD+Extension.swift
//  盗梦极客VR
//
//  Created by wl on 4/26/16.
//  Copyright © 2016 wl. All rights reserved.
//

import SVProgressHUD

extension SVProgressHUD {
    static func showMessage(message: String) {
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.showWithStatus(message)
    }
    static func showError(message: String) {
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.showErrorWithStatus(message)
    }
}
