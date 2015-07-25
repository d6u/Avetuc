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
}

func ==(lhs: EventType, rhs: EventType) -> Bool {
    switch (lhs, rhs) {
    case (.Account, .Account):
        return true
    case (.Friends(let l), .Friends(let r)):
        return l == r
    default:
        return false
    }
}
