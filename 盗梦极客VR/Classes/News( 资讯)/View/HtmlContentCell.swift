//
//  HtmlContentCell.swift
//  盗梦极客VR
//
//  Created by wl on 6/16/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import DTCoreText

protocol HtmlContentCellDelegate: class {
    func htmlContentCell(cell: HtmlContentCell, linkDidPress link:NSURL)
    func htmlContentCellSizeDidChange(cell: HtmlContentCell)
}

class HtmlContentCell: DTAttributedTextCell {

    private var imageViews = [DTLazyImageView]()
     weak var delegate: HtmlContentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textDelegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    deinit {
        for imageView in imageViews {
            imageView.delegate = nil
        }
    }
}

extension HtmlContentCell {
    
    func linkDidTap(sender: DTLinkButton) {
        if let url = sender.URL {
            delegate?.htmlContentCell(self, linkDidPress: url)
        }
    }
    
    
    private func aspectFitSizeForURL(url: NSURL) -> CGSize {
        let imageSize = imageSizes[url] ?? CGSizeMake(4, 3)
        return self.aspectFitImageSize(imageSize)
    }
    
    private func aspectFitImageSize(size : CGSize) -> CGSize {
        if CGSizeEqualToSize(size, CGSizeZero) {
            return size
        }
        return CGSizeMake(40, 40)
        //        return CGSizeMake(self.bounds.size.width, self.bounds.size.width/size.width * size.height)
    }
}

extension HtmlContentCell: DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForAttributedString string: NSAttributedString!, frame: CGRect) -> UIView! {
        
        let attributes = string.attributesAtIndex(0, effectiveRange: nil)
        let url = attributes[DTLinkAttribute] as? NSURL
        let identifier = attributes[DTGUIDAttribute] as? String
        
        let button = DTLinkButton(frame: frame)
        button.URL = url
        button.GUID = identifier
        button.minimumHitSize = CGSizeMake(25, 25)
        button.addTarget(self, action: #selector(linkDidTap(_:)), forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForAttachment attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if let attachment = attachment as? DTImageTextAttachment {
            let size = self.aspectFitSizeForURL(attachment.contentURL)
            let aspectFrame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height)
            
            let imageView = DTLazyImageView(frame: aspectFrame)
            
            imageView.delegate = self
            imageView.url = attachment.contentURL
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
            imageView.shouldShowProgressiveDownload = true
            imageViews.append(imageView)
            
            return imageView
        }else if let attachment = attachment as? DTIframeTextAttachment {
            let videoView = DTWebVideoView(frame: frame)
            videoView.attachment = attachment
            return videoView
        }
        return nil
    }
    
    // MARK: DTLazyImageViewDelegate
    func lazyImageView(lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        
        let url = lazyImageView.url
        let pred = NSPredicate(format: "contentURL == %@", url)
        
        var needsNotifyNewImageSize = false
        if let layoutFrame = self.attributedTextContextView.layoutFrame {
            var attachments = layoutFrame.textAttachmentsWithPredicate(pred)
            
            for i in 0 ..< attachments.count {
                if let one = attachments[i] as? DTImageTextAttachment {
                    
                    if CGSizeEqualToSize(one.originalSize, CGSizeZero) {
                        one.originalSize = aspectFitImageSize(size)
                        needsNotifyNewImageSize = true
                        
                    }
                }
            }
        }
        
        if needsNotifyNewImageSize {
            self.attributedTextContextView.layouter = nil
            self.attributedTextContextView.relayoutText()
            self.delegate?.htmlContentCellSizeDidChange(self)
        }
    }
}