//
//  ReplyCell.swift
//  盗梦极客VR
//
//  Created by wl on 5/11/16.
//  Copyright © 2016 wl. All rights reserved.
//  回复cell

import UIKit
import DTCoreText

protocol ReplyCellDelegate: class {
    func replyCell(cell: ReplyCell, linkDidPress link:NSURL)
    func replyCellSizeDidChange(cell: ReplyCell)
}

class ReplyCell: UITableViewCell, CoreTextViewDelegate {

    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var coreTextView: CoreTextView?
    
    weak var delegate: ReplyCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coreTextView?.linkDelegate = self
    }

    func configure(presenter: ReplyCellPresentable) {
        presenter.configTopImageView(userIcon)
        presenter.configTitleLabel(userNameLabel)
        presenter.configTimeLabel(timeLabel)
        presenter.confightmlTextView(coreTextView!)
    }
    
}

// MARK: CoreTextViewDelegate
extension ReplyCell {
    func coreTextView(textView: CoreTextView, linkDidTap link: NSURL) {
        self.delegate?.replyCell(self, linkDidPress: link)
    }
    
    func coreTextView(textView: CoreTextView, newImageSizeDidCache size: CGSize) {
        self.delegate?.replyCellSizeDidChange(self)
    }
}
