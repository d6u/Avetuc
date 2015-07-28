//
//  FriendsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask

typealias FriendsStoreData = (friends: [User], accountUserId: String)

class FriendsStore: Store {

    static let instance = FriendsStore()

    private var friends = [User]()
    private var currentAccountId: String?

    func perform(data: FriendsStoreData) -> Task<Int, FriendsStoreData, NSError>
    {
        return Task<Int, FriendsStoreData, NSError> { progress, fulfill, reject, configure in
            let sorted = self.sortFriends(data.friends)
            self.friends = sorted
            self.currentAccountId = data.accountUserId
            fulfill((friends: sorted, accountUserId: data.accountUserId))
        }
    }

    func updateUser(user: User) -> Task<Int, (indexPath: NSIndexPath, user: User), NSError> {
        return Task<Int, (indexPath: NSIndexPath, user: User), NSError> { progress, fulfill, reject, configure in

            for (i, u) in enumerate(self.friends) {
                if u.id == user.id {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    fulfill(indexPath: indexPath, user: user)
                    break
                }
            }

            reject(NSError(
                domain: "com.daiweilu.Avetuc",
                code: 100,
                userInfo: [
                    "desc": ""
                ]))
        }
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
