//
//  TweetsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask

typealias TweetsStoreData = (tweets: [Tweet], userId: Int64)

class TweetsStore: Store {

    static let instance = TweetsStore()

    private var userId: Int64?
    private var tweets = [Tweet]()

    func perform(data: TweetsStoreData) -> Task<Int, TweetsStoreData, NSError> {
        return Task<Int, TweetsStoreData, NSError> { progress, fulfill, reject, configure in
            self.tweets = data.tweets
            self.userId = data.userId
            fulfill((tweets: data.tweets, userId: data.userId))
        }
    }

}
