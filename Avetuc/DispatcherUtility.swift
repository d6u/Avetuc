//
//  EventUtilities.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

typealias AccountDataHandler = (AccountData?) -> Void

enum DispatcherEventType {
    case Account
    case Friends
    case Tweets
}
