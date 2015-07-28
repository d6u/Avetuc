//
//  EventType.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

enum EventType: Equatable {
    case Account
    case Friends(accountUserId: String)
    case FriendsUpdate
    case Tweets(userId: Int64)
    case Tweet(Int64)
    case TweetsUpdate
}

func ==(lhs: EventType, rhs: EventType) -> Bool {
    switch (lhs, rhs) {
    case (.Account, .Account):
        return true
    case (.Friends(let l), .Friends(let r)):
        return l == r
    case (.FriendsUpdate, .FriendsUpdate):
        return true
    case (.Tweets(let l), .Tweets(let r)):
        return l == r
    case (.Tweet(let l), .Tweet(let r)):
        return l == r
    case (.TweetsUpdate, .TweetsUpdate):
        return true
    default:
        return false
    }
}
