//
//  Action.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask
import RxSwift

func action_handleOauthCallback(url: NSURL) {
    sendNext(River.instance.action_handleOauthCallback, url)
}

func action_addAccountFromWeb() {
    sendNext(River.instance.action_addAccountFromWeb, ())
}

func action_updateAccount(account: Account) {
    sendNext(River.instance.action_updateAccount, account)
}

func action_selectFriend(id: Int64) {
    sendNext(River.instance.action_selectFriend, id)
}

func action_updateTweetReadState(id: Int64, isRead: Bool) {
    sendNext(River.instance.action_updateTweetReadState, (id, isRead))
}

// MARK: Deprecated

//private func dispatch<T>(type: EventType, #data: T) {
//    Dispatcher.instance.dispatch(type, data: data)
//}

// MARK: - Tweets

//func updateTweetReadState(id: Int64, isRead: Bool) {
//    LocalStorageService.instance.updateTweetReadState(id, isRead: isRead)
//        .success { (data: (tweet: Tweet, user: User)) -> Void in
//
//            TweetsStore.instance.updateTweet(data.tweet)
//                .success { (data: (userId: Int64, indexPath: NSIndexPath, tweet: ParsedTweet)) -> Void in
//                    dispatch(.TweetsUpdate, data: data)
//                    dispatch(.Tweet(data.tweet.tweet.id), data: data.tweet.tweet)
//                }
//
//            FriendsStore.instance.updateUser(data.user)
//                .success { (data: (indexPath: NSIndexPath, user: User)) -> Void in
//                    dispatch(.FriendsUpdate, data: data)
//                }
//        }
//}
