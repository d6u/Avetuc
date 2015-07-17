//
//  Dispatcher.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

class Dispatcher {

    class var instance: Dispatcher {
        struct Static {
            static var instance: Dispatcher?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = Dispatcher()
        }
        return Static.instance!
    }

    let accountEvent = Event<AccountData?>()
    let friendsEvent = Event<[UserData]>()

    func register(callback: AccountDataHandler) -> Listener {
        return accountEvent.on(callback)
    }

    func register(callback: FriendsDataHandler) -> Listener {
        return friendsEvent.on(callback)
    }

    func dispatch(account: AccountData?) {
        self.accountEvent.emit(account)
    }

    func dispatch(friends: [UserData]) {
        self.friendsEvent.emit(friends)
    }

}
