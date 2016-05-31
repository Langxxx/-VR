//
//  ReplyCell.swift
//  盗梦极客VR
//
//  Created by wl on 5/11/16.
//  Copyright © 2016 wl. All rights reserved.
//  回复cell

import UIKit

class ReplyCell: UITableViewCell {

    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(presenter: ReplyCellPresentable) {
        presenter.configTopImageView(userIcon)
        presenter.configTitleLabel(userNameLabel)
        presenter.configExcerptLabel(messageLabel)
        presenter.configTimeLabel(timeLabel)
    }
}
