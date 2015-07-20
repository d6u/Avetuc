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

let UNREAD_COUNT_BACKGROUND_COLOR = UIColor(netHex: 0xAAAAAA)

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

    var user: UserData?

    let profileImageView = ProfileImageView(frame: CGRect(x: 12, y: 13, width: 48, height: 48))
    let nameView = FriendCellNameLabel()
    let screenNameView = FriendCellScreenNameLabel()
    let unreadCountView = FriendCellUnreadCountView()

    func load(data: UserData) {
        self.user = data
        self.nameView.text = data.name
        self.screenNameView.text = "@\(data.screen_name)"
        self.unreadCountView.count = data.unread_count
//        self.profileImageView.kf_setImageWithURL(u.profileImageUrl, placeholderImage: nil)
//
//        if u.unreadCount > 0 {
//            self.addCellActions()
//        } else {
//            self.removeCellActions()
//        }
    }

//    func addCellActions() {
//        let markAllReadButton = MGSwipeButton(title: "Mark All Read", backgroundColor: UIColor.redColor()) {
//            (cell) -> Bool in
//            self.markAllTweetRead()
//            return true
//        }
//
//        self.rightButtons = [markAllReadButton]
//        self.rightSwipeSettings.transition = .Drag
//
//        let expansionSettings = MGSwipeExpansionSettings()
//        expansionSettings.buttonIndex = 0
//        expansionSettings.fillOnTrigger = true
//        self.rightExpansion = expansionSettings
//    }
//
//    func removeCellActions() {
//        self.rightButtons = []
//    }
//
//    func markAllTweetRead() {
//        let fetchRequest = NSFetchRequest(entityName: "Tweet")
//        fetchRequest.predicate = NSPredicate(format: "user = %@", self.user!)
//
//        let tweets = CoreDataStack.sharedInstance.mainContext.executeFetchRequest(fetchRequest, error: nil) as! [Tweet]
//
//        for tweet in tweets {
//            tweet.makeRead()
//        }
//    }
//
//    func profileImageTapped(gestureRecognizer: UIGestureRecognizer) {
//        friendTableCellDelegate?.friendTableCellShouldShowUserProfile(user!)
//    }

    // MARK: - Delegate Methods

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Prevent sub UIView lost background color on cell selected http://stackoverflow.com/questions/7053340
//        self.unreadCountView.backgroundColor = UNREAD_COUNT_BACKGROUND_COLOR
//    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
