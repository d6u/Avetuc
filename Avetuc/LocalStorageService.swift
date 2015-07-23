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

            let users = data.map { UserModel().fromApiData($0) }

            if let account = self.realm.objects(AccountModel).filter("user_id = %@", accountUserId).first {
                self.realm.write {
                    self.realm.add(users, update: true)
                    for u in users {
                        if account.friends.indexOf(u) == nil {
                            account.friends.append(u)
                        }
                    }
                }
            }

            fulfill(users.map { $0.toData() })
        }
    }

    func createTweets(
        tweetsData: [TweetApiData],
        master_account_user_id: String) -> CreateTweetsTask
    {
        return CreateTweetsTask { progress, fulfill, reject, configure in
            let realm = Realm()
            let tweets = tweetsData.map { TweetModel().fromApiData($0) }
            realm.write {
                realm.add(tweets, update: true)
            }
            let data = tweets.map { $0.toData() }
            fulfill(data)
        }
    }

    // MARK: Read

    func loadDefaultAccount() {
        let realm = Realm()
        if let model = realm.objects(AccountModel).first {
            let account = model.toData()
            TwitterApiService.instance.loadTokens(
                oauthToken: account.oauth_token,
                oauthTokenSecret: account.oauth_token_secret)
            emitAccount(account)
        } else {
            emitAccount(nil)
        }
    }

    func loadFriendsFor(user_id: String) {
        let realm = Realm()
        if let account = realm.objects(AccountModel).filter("user_id = %@", user_id).first {
            emitFriends(Array(account.friends).map { $0.toData() })
        }
    }

    func loadStatuses(user_id: String) {
        let realm = Realm()
        emitTweets(Array(realm.objects(TweetModel)).map { $0.toData() })
    }

//    // Mark: - Update
//
//    func updateAccountLastestSinceId(user_id: String, latest_id: String) {
//        let realm = Realm()
//        let account = realm.objects(Account).filter("user_id == %@", user_id).first!
//
//        realm.write {
//            account.last_fetch_since_id = latest_id
//        }
//    }

}
