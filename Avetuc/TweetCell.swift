//
//  TweetCell.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import TapLabel
import SnapKit

let TWEET_CELL_MAIN_CONTENT_WIDTH = screenBounds().width - 68 - 10
let TWEET_CELL_IMAGE_BOX_HEIGHT = ceil(TWEET_CELL_MAIN_CONTENT_WIDTH / 2)

class TweetCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsMake(0, 68, 0, 0)

        self.contentView.addSubview(self.textView)
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.userNameView)
//        self.contentView.addSubview(self.imageBoxView)
        self.contentView.addSubview(self.unreadIndicatorView)
        self.contentView.addSubview(self.timeText)

        self.textView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(68)
            make.right.equalTo(self).offset(-10)
        }

        self.timeText.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-13)
        }

        self.userNameView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(68)
            make.top.equalTo(self).offset(6)
            make.right.equalTo(self).offset(-10)
        }

//        self.imageBoxView.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(self.textView.snp_bottom).offset(10)
//            make.left.equalTo(self).offset(68)
//        }

        self.unreadIndicatorView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(0)
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(0)
            make.width.equalTo(3)
        }

//        self.contentView.addConstraint(self.tweetTextViewTopConstraint)

//        self.imageBoxView.hidden = true
    }

    let unreadIndicatorView = UnreadIndicatorView()
    let profileImageView = ProfileImageView(frame: CGRect(x: 12, y: 13, width: 48, height: 48))
    let textView = TweetTextView()
    let timeText = TimestampView()
//    let retweetedText = UILabel()
//    let embeddedImage = UIImageView()
    let userNameView = UserNameLabel()
//    let imageBoxView = ImageBoxView(frame: CGRect(x: 68, y: 0, width: TWEET_CELL_MAIN_CONTENT_WIDTH, height: TWEET_CELL_IMAGE_BOX_HEIGHT))

//    lazy var tweetTextViewTopConstraint: NSLayoutConstraint = {
//        return NSLayoutConstraint(
//            item: self.textView,
//            attribute: .Top,
//            relatedBy: .Equal,
//            toItem: self.contentView,
//            attribute: .Top,
//            multiplier: 1,
//            constant: 11)
//        }()

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
