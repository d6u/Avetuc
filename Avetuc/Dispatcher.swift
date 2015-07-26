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
typealias TweetsDataHandler = ([Tweet]) -> Void

class Dispatcher {

    class WeakConsumer {
        weak var value : EventConsumer?
        init (value: EventConsumer) {
            self.value = value
        }
    }

    static let instance = Dispatcher()

    var weakConsumers = [WeakConsumer]()

    func register(consumer: EventConsumer) {
        self.weakConsumers.append(WeakConsumer(value: consumer))
    }

    func dispatch<T>(eventType: EventType, data: T) {
        for weak in self.weakConsumers {
            if let c = weak.value {
                if c.type == eventType {
                    c.consume(data)
                }
            }
        }

        // Clean up deinit objects
        self.weakConsumers = self.weakConsumers.filter { $0.value != nil }
    }

    // MARK: - Deprecated

    let accountEvent = Event<Account?>()
    let friendsEvent = Event<[User]>()
    let tweetsEvent = Event<[Tweet]>()

    func register(callback: AccountDataHandler) -> Listener {
        return accountEvent.on(callback)
    }

    func register(callback: FriendsDataHandler) -> Listener {
        return friendsEvent.on(callback)
    }

    func register(callback: TweetsDataHandler) -> Listener {
        return tweetsEvent.on(callback)
    }

    func dispatch(account: Account?) {
        self.accountEvent.emit(account)
    }

    func dispatch(friends: [User]) {
        self.friendsEvent.emit(friends)
    }

    func dispatch(tweets: [Tweet]) {
        self.tweetsEvent.emit(tweets)
    }

}
