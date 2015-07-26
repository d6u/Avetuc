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

class TweetsStore: Store {

    static let instance = TweetsStore()

    private var userId: Int64?
    private var tweets = [ParsedTweet]()

    func perform(data: (tweets: [TweetAndRetweet], userId: Int64)) -> Task<Int, TweetsStoreData, NSError> {
        return Task<Int, TweetsStoreData, NSError> { progress, fulfill, reject, configure in
            self.tweets = data.tweets.map { parseTweet($0) }
            self.userId = data.userId
            fulfill((tweets: self.tweets, userId: data.userId))
        }
    }

    func updateTweet(tweet: Tweet) -> Task<Int, (userId: Int64, indexPath: NSIndexPath, tweet: ParsedTweet), NSError> {
        return Task<Int, (userId: Int64, indexPath: NSIndexPath, tweet: ParsedTweet), NSError> {
            progress, fulfill, reject, configure in

            for (i, t) in enumerate(self.tweets) {
                if t.tweet.id == tweet.id {
                    let parsedTweet = ParsedTweet(
                        tweet: tweet,
                        retweetedStatus: t.retweetedStatus,
                        retweetedStatusUser: t.retweetedStatusUser,
                        text: t.text
                    )

                    self.tweets[i] = parsedTweet

                    fulfill(
                        userId: self.userId!,
                        indexPath: NSIndexPath(forRow: i, inSection: 0),
                        tweet: parsedTweet
                    )

                    return
                }
            }

            reject(NSError(
                domain: "com.daiweilu.Avetuc",
                code: 100,
                userInfo: [
                    "desc": ""
                ]))
        }
    }

}
