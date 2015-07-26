//
//  Action.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask

private func dispatch<T>(type: EventType, #data: T) {
    Dispatcher.instance.dispatch(type, data: data)
}

// MARK: - API

let loadTokens = TwitterApiService.instance.loadTokens

func handleCallbackUrl(url: NSURL) {
    TwitterApiService.instance.handleOauthCallback(url)
}

// MARK: - Account

enum AccountResult {
    case NoAccount
    case Success(Account)
    case UserReject
}

func loadDefaultAccount() {
    LocalStorageService.instance.loadDefaultAccount()
        .success { account -> Void in
            if let account = account {
                dispatch(.Account, data: AccountResult.Success(account))
            } else {
                dispatch(.Account, data: AccountResult.NoAccount)
            }
        }
}

func addAccountThroughWeb() {
    TwitterApiService.instance.addAccountThroughWeb()
        .success { result -> Void in
            dispatch(.Account, data: result)
        }
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
        .success { (tweet: Tweet) -> Task<Int, (userId: Int64, indexPath: NSIndexPath, tweet: ParsedTweet), NSError> in
            return TweetsStore.instance.updateTweet(tweet)
        }
        .success { (data: (userId: Int64, indexPath: NSIndexPath, tweet: ParsedTweet)) -> Void in
            dispatch(.TweetsUpdate, data: data)
            dispatch(.Tweet(data.tweet.tweet.id), data: data.tweet.tweet)
        }
}

// MARK: - Remote Data

func fetchFriendsOfAccount(user_id: String) {
    // TODO: dispatch data
    TwitterApiService.instance.fetchFriendsOfAccount(user_id)
}

func fetchHomeTimelineOfAccount(user_id: String, #since_id: Int64?) {
    // TODO: dispatch data
    TwitterApiService.instance.fetchHomeTimelineOfAccount(user_id, since_id: since_id == nil ? nil : String(since_id!))
}
