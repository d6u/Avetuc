//
//  TweetsAction.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct TweetsActions {

    static func fetchHomeTimeline(since_id: String?) {
        TwitterApiService.instance.fetchHomeTimeline(since_id)
    }
    
}
