//
//  ReplyTitleCell.swift
//  盗梦极客VR
//
//  Created by wl on 5/11/16.
//  Copyright © 2016 wl. All rights reserved.
//  回复cell

import UIKit

class ReplyTitleCell: UITableViewCell {

    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(presenter: ReplyTitleCellPresentable) {
        presenter.configTopImageView(userIcon)
        presenter.configTitleLabel(userNameLabel)
        presenter.configTimeLabel(timeLabel)
    }
    
}