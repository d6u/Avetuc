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
    case Tweets(userId: Int64)
}

func ==(lhs: EventType, rhs: EventType) -> Bool {
    switch (lhs, rhs) {
    case (.Account, .Account):
        return true
    case (.Friends(let l), .Friends(let r)):
        return l == r
    case (.Tweets(let l), .Tweets(let r)):
        return l == r
    default:
        return false
    }
}
