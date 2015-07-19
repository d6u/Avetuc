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

        self.nameView.font = UIFont(name: "HelveticaNeue-Bold", size: 18)

//        self.screenNameView.font = UIFont(name: "HelveticaNeue", size: 15)
//        self.screenNameView.textColor = UIColor.grayColor()
//        self.screenNameView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.contentView.addSubview(self.screenNameView)
//        self.contentView.addConstraint(NSLayoutConstraint(
//            item: self.screenNameView,
//            attribute: .Top,
//            relatedBy: .Equal,
//            toItem: self.contentView,
//            attribute: .Top,
//            multiplier: 1,
//            constant: 39))
//        self.contentView.addConstraint(NSLayoutConstraint(
//            item: self.screenNameView,
//            attribute: .Left,
//            relatedBy: .Equal,
//            toItem: self.contentView,
//            attribute: .Left,
//            multiplier: 1,
//            constant: 72))
//        self.contentView.addConstraint(NSLayoutConstraint(
//            item: self.screenNameView,
//            attribute: .Right,
//            relatedBy: .Equal,
//            toItem: self.contentView,
//            attribute: .Right,
//            multiplier: 1,
//            constant: -60))
//
//        self.unreadCountView.backgroundColor = UNREAD_COUNT_BACKGROUND_COLOR
//        self.unreadCountView.layer.cornerRadius = 4
//        self.unreadCountView.layer.masksToBounds = true
//        self.unreadCountView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.contentView.addSubview(self.unreadCountView)
//        self.contentView.addConstraint(NSLayoutConstraint(
//            item: self.unreadCountView,
//            attribute: .Right,
//            relatedBy: .Equal,
//            toItem: self.contentView,
//            attribute: .Right,
//            multiplier: 1,
//            constant: -15))
//        self.contentView.addConstraint(NSLayoutConstraint(
//            item: self.unreadCountView,
//            attribute: .Top,
//            relatedBy: .Equal,
//            toItem: self.contentView,
//            attribute: .Top,
//            multiplier: 1,
//            constant: 24))
//
//        self.unreadCountSubView.textColor = UIColor.whiteColor()
//        self.unreadCountSubView.font = UIFont(name: "HelveticaNeue", size: 15)
//        self.unreadCountSubView.textAlignment = .Center
//        self.unreadCountSubView.setTranslatesAutoresizingMaskIntoConstraints(false)
//
//        self.unreadCountView.addSubview(self.unreadCountSubView)
//        self.unreadCountView.addConstraint(NSLayoutConstraint(
//            item: self.unreadCountSubView,
//            attribute: .Right,
//            relatedBy: .Equal,
//            toItem: self.unreadCountView,
//            attribute: .Right,
//            multiplier: 1,
//            constant: -5))
//        self.unreadCountView.addConstraint(NSLayoutConstraint(
//            item: self.unreadCountSubView,
//            attribute: .Top,
//            relatedBy: .Equal,
//            toItem: self.unreadCountView,
//            attribute: .Top,
//            multiplier: 1,
//            constant: 3))
//        self.unreadCountView.addConstraint(NSLayoutConstraint(
//            item: self.unreadCountSubView,
//            attribute: .Bottom,
//            relatedBy: .Equal,
//            toItem: self.unreadCountView,
//            attribute: .Bottom,
//            multiplier: 1,
//            constant: -3))
//        self.unreadCountView.addConstraint(NSLayoutConstraint(
//            item: self.unreadCountSubView,
//            attribute: .Left,
//            relatedBy: .Equal,
//            toItem: self.unreadCountView,
//            attribute: .Left,
//            multiplier: 1,
//            constant: 5))
//
//        self.unreadCountSubView.addConstraint(NSLayoutConstraint(
//            item: self.unreadCountSubView,
//            attribute: .Width,
//            relatedBy: .GreaterThanOrEqual,
//            toItem: nil,
//            attribute: .NotAnAttribute,
//            multiplier: 1,
//            constant: 15))

        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.nameView)

        self.nameView.snp_makeConstraints { make in
            make.left.equalTo(self.contentView.snp_left).offset(72)
            make.right.equalTo(self.contentView.snp_right).offset(-60)
            make.top.equalTo(self.contentView.snp_top).offset(15)
        }
    }

    var user: UserData?

    let profileImageView = FriendCellProfileImageView(frame: CGRect(x: 12, y: 13, width: 48, height: 48))
    let nameView = UILabel(frame: CGRect())
    let screenNameView = UILabel(frame: CGRect())
    let unreadCountView = UIView(frame: CGRect())
    let unreadCountSubView = UILabel(frame: CGRect())

    func load(data: UserData) {
        self.user = data
        self.nameView.text = data.name
//        self.screenNameView.text = "@\(u.screenName)"
//        self.unreadCountSubView.text = String(u.unreadCount)
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
