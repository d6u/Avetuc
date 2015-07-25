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
        .success { (tweets: [Tweet]) -> Task<Int, TweetsStoreData, NSError> in
            return TweetsStore.instance.perform((tweets: tweets, userId: id))
        }
        .success { (data: TweetsStoreData) -> Void in
            dispatch(.Tweets(userId: data.userId), data: data.tweets)
        }
}
