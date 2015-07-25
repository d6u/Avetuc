//
//  TweetsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask

typealias TweetsStoreData = (tweets: [ParsedTweet], userId: Int64)

struct ParsedTweet {
    let tweet: Tweet
    let text: String
}

class TweetsStore: Store {

    static let instance = TweetsStore()

    private var userId: Int64?
    private var tweets = [ParsedTweet]()

    func perform(data: (tweets: [Tweet], userId: Int64)) -> Task<Int, TweetsStoreData, NSError> {
        return Task<Int, TweetsStoreData, NSError> { progress, fulfill, reject, configure in
            self.tweets = data.tweets.map { parseTweet($0) }
            self.userId = data.userId
            fulfill((tweets: self.tweets, userId: data.userId))
        }
    }

}
