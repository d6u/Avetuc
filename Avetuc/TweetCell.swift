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

    static func heightForContent(tweet: ParsedTweet) -> CGFloat {
        let boundingRect = tweet.text.boundingRectWithSize(
            CGSizeMake(TWEET_CELL_TEXT_WIDTH, CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin | NSStringDrawingOptions.UsesFontLeading,
            context: nil)
        return ceil(boundingRect.size.height) + (tweet.retweetedStatus == nil ? 10 : 30) + 33
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)

        self.contentView.addSubview(self.textView)
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.userNameView)
        self.contentView.addSubview(self.timeText)

        self.timeText.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-13)
        }

        self.userNameView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(68)
            make.top.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-10)
        }
    }

    let profileImageView = ProfileImageView(frame: CGRect(x: 12, y: 13, width: 48, height: 48))
    let textView = TweetTextView()
    let timeText = TimestampView()
    let userNameView = UserNameLabel()

    func loadTweet(parsedTweet: ParsedTweet, userData: User) {
        self.textView.attributedText = parsedTweet.text
        self.timeText.text = relativeTimeString(parseTwitterTimestamp(parsedTweet.tweet.created_at))

        if let retweeted = parsedTweet.retweetedStatus {
            self.profileImageView.frame = CGRect(x: 12, y: 33, width: 48, height: 48)
            self.userNameView.text = userData.name
        }
        else {
            self.profileImageView.frame = CGRect(x: 12, y: 13, width: 48, height: 48)
            self.userNameView.text = nil
            self.profileImageView.updateImage(userData.profile_image_url)
        }

        self.textView.snp_updateConstraints { make in
            make.left.equalTo(self).offset(68)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(parsedTweet.retweetedStatus == nil ? 10 : 30)
        }
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
