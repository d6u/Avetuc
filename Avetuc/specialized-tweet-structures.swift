//
//  specialized-tweet.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/26/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct TweetAndRetweet {
    let tweet: Tweet
    let retweetedStatus: Tweet?
}

struct ParsedTweet {
    let tweet: Tweet
    let retweetedStatus: Tweet?
    let text: NSAttributedString
}
