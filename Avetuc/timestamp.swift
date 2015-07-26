//
//  BaseModel.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/6/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

private let formatter: NSDateFormatter = {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    return formatter
}()

func parseTwitterTimestamp(string: String) -> NSDate {
    return formatter.dateFromString(string)!
}

func relativeTimeString(date: NSDate) -> String {
    var dis = Int(-date.timeIntervalSinceNow)

    if dis < 60 {
        return "\(dis)s"
    }

    dis = dis / 60
    if dis < 60 {
        return "\(dis)m"
    }

    dis = dis / 60
    if dis < 24 {
        return "\(dis)h"
    }

    dis = dis / 24

    return dis > 1 ? "\(dis) days" : "\(dis) day"
}
