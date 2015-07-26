//
//  ModelActions.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

// Actions

func handleCallbackUrl(url: NSURL) {
    TwitterApiService.instance.handleOauthCallback(url)
}

// Fetch remote data

func fetchFriendsOfAccount(user_id: String) {
    TwitterApiService.instance.fetchFriendsOfAccount(user_id)
}

func fetchHomeTimelineOfAccount(user_id: String, #since_id: Int64?) {
    TwitterApiService.instance.fetchHomeTimelineOfAccount(user_id, since_id: since_id == nil ? nil : String(since_id!))
}
