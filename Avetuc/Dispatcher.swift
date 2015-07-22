//
//  Dispatcher.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

typealias AccountDataHandler = (Account?) -> Void
typealias FriendsDataHandler = ([User]) -> Void
//typealias TweetsDataHandler = ([TweetData]) -> Void

class Dispatcher {

    static let instance = Dispatcher()

    let accountEvent = Event<Account?>()
    let friendsEvent = Event<[User]>()
//    let tweetsEvent = Event<[TweetData]>()

    func register(callback: AccountDataHandler) -> Listener {
        return accountEvent.on(callback)
    }

    func register(callback: FriendsDataHandler) -> Listener {
        return friendsEvent.on(callback)
    }
//
//    func register(callback: TweetsDataHandler) -> Listener {
//        return tweetsEvent.on(callback)
//    }

    func dispatch(account: Account?) {
        self.accountEvent.emit(account)
    }

    func dispatch(friends: [User]) {
        self.friendsEvent.emit(friends)
    }
//
//    func dispatch(tweets: [TweetData]) {
//        self.tweetsEvent.emit(tweets)
//    }

}
