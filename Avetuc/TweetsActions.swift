//
//  TweetsAction.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct TweetsActions {

    static func fetchHomeTimeline(user_id: String, since_id: Int64?) {
        TwitterApiService.instance.fetchHomeTimeline(user_id, since_id: since_id == nil ? nil : String(since_id!))
    }

    static func loadStatuses(user_id: String) {
        LocalStorageService.instance.loadStatuses(user_id)
    }

    static func emitTweets(tweets: [Tweet]) {
//        Dispatcher.instance.dispatch(tweets)
    }
    
}
