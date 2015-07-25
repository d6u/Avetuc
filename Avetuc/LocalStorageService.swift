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

typealias CreateAccountTask = Task<Float, Account, NSError>
typealias CreateUsersTask = Task<Float, [User], NSError>
typealias CreateTweetsTask = Task<Float, [Tweet], NSError>

class LocalStorageService {

    static let instance = LocalStorageService()

    let realm = Realm()

    // MARK: Create

    func createAccount(data: AccountApiData) -> CreateAccountTask {
        return CreateAccountTask { progress, fulfill, reject, configure in
            let model = AccountModel().fromApiData(data)
            self.realm.write {
                self.realm.add(model, update: true)
            }
            fulfill(model.toData())
        }
    }

    func createUsers(data: [UserApiData], accountUserId: String) -> CreateUsersTask
    {
        return CreateUsersTask { progress, fulfill, reject, configure in

            let account = self.realm.objects(AccountModel).filter("user_id = %@", accountUserId).first!

            var users = [UserModel]()

            self.realm.write {
                for d in data {
                    if let user = account.friends.filter("id = %ld", d.id).first {
                        user.fromApiData(d, update: true)
                        users.append(user)
                    } else {
                        let user = UserModel().fromApiData(d)
                        users.append(user)
                    }
                }

                self.realm.add(users, update: true)

                for u in users {
                    if account.friends.indexOf(u) == nil {
                        account.friends.append(u)
                    }
                }
            }

            fulfill(users.map { $0.toData() })
        }
    }

    func createTweets(data: [TweetApiData], account_user_id: String) -> CreateTweetsTask
    {
        return CreateTweetsTask { progress, fulfill, reject, configure in

            let account = self.realm.objects(AccountModel).filter("user_id = %@", account_user_id).first!

            var tweetsData = [Tweet]()

            self.realm.write {
                for d in data {
                    let tweet = TweetModel().fromApiData(d)
                    self.realm.add(tweet, update: true)

                    let user = account.friends.filter("id = %ld", d.user.id).first!
                    user.statuses.append(tweet)
                    user.unread_status_count += 1

                    tweetsData.append(tweet.toData())
                }
            }

            fulfill(tweetsData)
        }
    }

    // MARK: Read

    func loadDefaultAccount() -> Task<Void, Account?, NSError> {
        return Task<Void, Account?, NSError> { progress, fulfill, reject, configure in
            if let model = self.realm.objects(AccountModel).first {
                fulfill(model.toData())
            } else {
                fulfill(nil)
            }
        }
    }

    func loadFriendsFor(user_id: String) {
        if let account = self.realm.objects(AccountModel).filter("user_id = %@", user_id).first {
            emitFriends(Array(account.friends).map { $0.toData() })
        }
    }

    func loadStatusesOfUser(id: Int64) {
        let user = self.realm.objects(UserModel).filter("id = %ld", id).first!
        emitTweets(Array(user.statuses).map { $0.toData() })
    }

    // Mark: - Update

    func updateAccount(user_id: String, lastest_since_id: Int64) {
        let account = self.realm.objects(AccountModel).filter("user_id == %@", user_id).first!
        self.realm.write {
            account.last_fetch_since_id = lastest_since_id
        }
    }

}
