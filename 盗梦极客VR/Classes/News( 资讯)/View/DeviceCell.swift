//
//  DeviceCell.swift
//  盗梦极客VR
//
//  Created by wl on 5/15/16.
//  Copyright © 2016 wl. All rights reserved.
//  设备详情的cell

import UIKit

class DeviceCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tagLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(presenter: DeviceCellPresentable) {
        presenter.configTopImageView(icon)
        presenter.configTitleLabel(titleLabel)
        presenter.configTimeLabel(timeLabel)
        presenter.configTageString(tagLable)
    }
}
