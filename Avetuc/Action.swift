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

// MARK: Deprecated

private func dispatch<T>(type: EventType, #data: T) {
    Dispatcher.instance.dispatch(type, data: data)
}

// MARK: - Account

enum AccountResult {
    case NoAccount
    case Success(Account)
    case UserReject
}

// MARK: - Friends

func loadAllFriendsOfAccount(user_id: String) {
    LocalStorageService.instance.loadFriendsFor(user_id)
        .success { (users: [User]) -> Task<Int, FriendsStoreData, NSError> in
            return FriendsStore.instance.perform((friends: users, accountUserId: user_id))
        }
        .success { (data: FriendsStoreData) -> Void in
            dispatch(.Friends(accountUserId: data.accountUserId), data: data.friends)
        }
}

// MARK: - Tweets

func loadStatusesOfUser(id: Int64) {
    LocalStorageService.instance.loadStatusesOfUser(id)
        .success { (tweets: [TweetAndRetweet]) -> Task<Int, TweetsStoreData, NSError> in
            return TweetsStore.instance.perform((tweets: tweets, userId: id))
        }
        .success { (data: TweetsStoreData) -> Void in
            dispatch(.Tweets(userId: data.userId), data: data.tweets)
        }
}

func updateTweetReadState(id: Int64, isRead: Bool) {
    LocalStorageService.instance.updateTweetReadState(id, isRead: isRead)
        .success { (data: (tweet: Tweet, user: User)) -> Void in

            TweetsStore.instance.updateTweet(data.tweet)
                .success { (data: (userId: Int64, indexPath: NSIndexPath, tweet: ParsedTweet)) -> Void in
                    dispatch(.TweetsUpdate, data: data)
                    dispatch(.Tweet(data.tweet.tweet.id), data: data.tweet.tweet)
                }

            FriendsStore.instance.updateUser(data.user)
                .success { (data: (indexPath: NSIndexPath, user: User)) -> Void in
                    dispatch(.FriendsUpdate, data: data)
                }
        }
}

// MARK: - Remote Data

func fetchFriendsOfAccount(user_id: String) {
    TwitterApiService.instance.fetchFriendsOfAccount(user_id)
        .success { (friends: [User]) -> Void in
            dispatch(.Friends(accountUserId: user_id), data: friends)
        }
}

func fetchHomeTimelineOfAccount(user_id: String, #since_id: Int64?) {
    TwitterApiService.instance.fetchHomeTimelineOfAccount(user_id, since_id: since_id == nil ? nil : String(since_id!))
        .success { () -> Void in
            loadAllFriendsOfAccount(user_id)
        }
}
