//
//  NewsCell.swift
//  盗梦极客VR
//
//  Created by wl on 4/26/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var excerptLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(presenter: NewsCellPresentable) {
        presenter.configTopImageView(topImageView)
        presenter.configTitleLabel(titleLabel)
        presenter.configExcerptLabel(excerptLabel)
        presenter.configTimeLabel(timeLabel)
        presenter.configReplyCountLabel(replyCountLabel)
        presenter.configTageString(tagLabel)
    }
}
