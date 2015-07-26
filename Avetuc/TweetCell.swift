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

class TweetCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsMake(0, 68, 0, 0)

        self.contentView.addSubview(self.textView)
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.userNameView)
        self.contentView.addSubview(self.unreadIndicatorView)
        self.contentView.addSubview(self.timeText)

        self.textView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(68)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(30)
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

        self.unreadIndicatorView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(0)
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(0)
            make.width.equalTo(3)
        }
    }

    let unreadIndicatorView = UnreadIndicatorView()
    let profileImageView = ProfileImageView(frame: CGRect(x: 12, y: 13, width: 48, height: 48))
    let textView = TweetTextView()
    let timeText = TimestampView()
    let userNameView = UserNameLabel()

    func loadTweet(parsedTweet: ParsedTweet, userData: User) {
        self.userNameView.text = userData.name
        self.profileImageView.updateImage(userData.profile_image_url)
        self.textView.attributedText = parsedTweet.text
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
