//
//  FriendsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

typealias FriendsStoreEventHandler = (StoreEvent<[User]>) -> Void

class FriendsStore {

    static let instance = FriendsStore()

    init() {
        self.listener = Dispatcher.instance.register { (friends: [User]) -> Void in
            let sorted = self.sortFriends(friends)
            self.event.emit(StoreEvent<[User]>(cur: sorted, pre: self.friends))
            self.friends = sorted
        }
    }

    private var friends = [User]()
    private let event = Event<StoreEvent<[User]>>()
    private var listener: Listener?

    func on(callback: FriendsStoreEventHandler) -> Listener {
        return event.on(callback)
    }

    func sortFriends(friends: [User]) -> [User] {
        return multiSort(friends, [
            {
                if $0.unread_status_count > $1.unread_status_count {
                    return .LeftFirst
                } else if $0.unread_status_count < $1.unread_status_count {
                    return .RightFirst
                } else {
                    return .Same
                }
            },
            {
                if $0.name < $1.name {
                    return .LeftFirst
                } else if $0.name > $1.name {
                    return .RightFirst
                } else {
                    return .Same
                }
            }
        ])
    }
    
}
