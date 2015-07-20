//
//  TweetsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

typealias TweetsStoreEventHandler = (StoreEvent<[TweetData]>) -> Void

class TweetsStore {

    class var instance: TweetsStore {
        struct Static {
            static var instance: TweetsStore?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = TweetsStore()
        }
        return Static.instance!
    }

    init() {
        self.listener = Dispatcher.instance.register { (tweets: [TweetData]) -> Void in

            // TODO: Diff
            self.event.emit(StoreEvent<[TweetData]>(cur: tweets, pre: self.tweets))

            self.tweets = tweets
        }
    }

    private var tweets = [TweetData]()
    private let event = Event<StoreEvent<[TweetData]>>()
    private var listener: Listener?

    func on(callback: TweetsStoreEventHandler) -> Listener {
        return event.on(callback)
    }
    
}
