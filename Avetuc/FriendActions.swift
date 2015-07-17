//
//  FriendActions.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

struct FriendActions {

    static func loadAllFriends(user_id: String) {
        LocalStorageService.instance.loadFriendsFor(user_id)
    }

    static func emitFriends(friends: [UserData]) {
        Dispatcher.instance.dispatch(friends)
    }

}
