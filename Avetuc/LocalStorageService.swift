//
//  LocalStoreService.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask
import RealmSwift
import Async

class LocalStorageService {

    static let instance = LocalStorageService()

    let realm = Realm()

    // Mark: - Update

    func updateTweetReadState(id: Int64, isRead: Bool) -> Task<Void, (Tweet, User), Void> {
        return Task<Void, (Tweet, User), Void> { progress, fulfill, reject, configure in
            let tweet = self.realm.objects(TweetModel).filter("id == %ld", id).first!

            if tweet.is_read != isRead {
                self.realm.write {
                    tweet.is_read = isRead
                    tweet.user!.unread_status_count -= 1
                }
            }

            fulfill((tweet.toData(), tweet.user!.toData()))
        }
    }

}
