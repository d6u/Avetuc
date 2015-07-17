//
//  FriendsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

typealias FriendsStoreEventHandler = (StoreEvent<[UserData]>) -> Void

class FriendsStore {

    class var instance: FriendsStore {
        struct Static {
            static var instance: FriendsStore?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = FriendsStore()
        }
        return Static.instance!
    }

    init() {
        self.listener = Dispatcher.instance.register { (friends: [UserData]) -> Void in

            // TODO: Diff
            self.event.emit(StoreEvent<[UserData]>(cur: friends, pre: self.friends))

            self.friends = friends
        }
    }

    private var friends = [UserData]()

    private let event = Event<StoreEvent<[UserData]>>()
    private var listener: Listener?

    func on(callback: FriendsStoreEventHandler) -> Listener {
        return event.on(callback)
    }
    
}
