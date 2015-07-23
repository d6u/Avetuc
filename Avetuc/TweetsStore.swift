//
//  TweetsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

typealias TweetsStoreEventHandler = (StoreEvent<[Tweet]>) -> Void

class TweetsStore {

    static let instance = TweetsStore()

    init() {
        self.listener = Dispatcher.instance.register { (tweets: [Tweet]) -> Void in

            self.event.emit(StoreEvent<[Tweet]>(cur: tweets, pre: self.tweets))
            self.tweets = tweets
        }
    }

    private var tweets = [Tweet]()
    private let event = Event<StoreEvent<[Tweet]>>()
    private var listener: Listener?

    func on(callback: TweetsStoreEventHandler) -> Listener {
        return event.on(callback)
    }
    
}
