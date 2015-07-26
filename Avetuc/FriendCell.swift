//
//  FriendCell.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FriendTableCell: UITableViewCell {

    static func heightForContent() -> CGFloat {
        return 74
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsMake(0, 72, 0, 0)

        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.nameView)
        self.contentView.addSubview(self.screenNameView)
        self.contentView.addSubview(self.unreadCountView)

        self.nameView.snp_makeConstraints { make in
            make.left.equalTo(self).offset(72)
            make.right.equalTo(self).offset(-60)
            make.top.equalTo(self).offset(15)
        }

        self.screenNameView.snp_makeConstraints { make in
            make.top.equalTo(self).offset(39)
            make.left.equalTo(self).offset(72)
            make.right.equalTo(self).offset(-60)
        }

        self.unreadCountView.snp_makeConstraints { make in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self).offset(24)
        }
    }

    let profileImageView = ProfileImageView(frame: CGRect(x: 12, y: 13, width: 48, height: 48))
    let nameView = FriendCellNameLabel()
    let screenNameView = FriendCellScreenNameLabel()
    let unreadCountView = FriendCellUnreadCountView()

    var user: User?

    func load(user: User) {
        self.user = user
        self.nameView.text = user.name
        self.screenNameView.text = "@\(user.screen_name)"
        self.unreadCountView.count = user.unread_status_count
        self.profileImageView.updateImage(user.profile_image_url)
    }

    // MARK: - Delegate

    // Prevent sub UIView lost background color
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.unreadCountView.backgroundColor = UNREAD_COUNT_BACKGROUND_COLOR
    }

    // Prevent sub UIView lost background color
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.unreadCountView.backgroundColor = UNREAD_COUNT_BACKGROUND_COLOR
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
