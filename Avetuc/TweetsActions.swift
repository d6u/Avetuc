//
//  TweetsAction.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct TweetsActions {

    static func fetchHomeTimeline(user_id: String, since_id: String?) {
        TwitterApiService.instance.fetchHomeTimeline(user_id, since_id: since_id)
    }
    
}
