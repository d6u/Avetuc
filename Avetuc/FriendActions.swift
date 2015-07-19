//
//  FriendActions.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct FriendActions {

    static func loadAllFriends(user_id: String) {
        LocalStorageService.instance.loadFriendsFor(user_id)
    }

    static func emitFriends(friends: [UserData]) {
        Dispatcher.instance.dispatch(friends)
    }

    static func fetchFriends(user_id: String) {
        TwitterApiService.instance.fetchFriends(user_id)
    }

}
