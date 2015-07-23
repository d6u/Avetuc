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

    // MARK: Create

    func createAccount(data: AccountApiData) -> CreateAccountTask {
        return CreateAccountTask { progress, fulfill, reject, configure in
            let realm = Realm()
            let model = AccountModel().fromApiData(data)
            realm.write {
                realm.add(model, update: true)
            }
            fulfill(model.toData())
        }
    }

    func createUsers(
        usersData: [UserApiData],
        following_account_user_id: String? = nil,
        profile_account_user_id: String? = nil
    ) -> CreateUsersTask
    {
        return CreateUsersTask { progress, fulfill, reject, configure in
            let realm = Realm()

            let users = usersData.map { UserModel().fromApiData($0) }

            if let id = following_account_user_id, let account = realm.objects(AccountModel).filter("user_id = %@", id).first {
                realm.write {
                    realm.add(users, update: true)
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
        master_account_user_id: String
    ) -> CreateTweetsTask
    {
        return CreateTweetsTask { progress, fulfill, reject, configure in
            let realm = Realm()
            let tweets = tweetsData.map { TweetModel().fromApiData($0) }
            realm.write {
                realm.add(tweets, update: true)
            }
            let data = tweets.map { $0.toData() }
            TweetsActions.emitTweets(data)
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
            AccountActions.emitAccount(account)
        } else {
            AccountActions.emitAccount(nil)
        }
    }

    func loadFriendsFor(user_id: String) {
        let realm = Realm()
        if let account = realm.objects(AccountModel).filter("user_id = %@", user_id).first {
            FriendActions.emitFriends(Array(account.friends).map { $0.toData() })
        }
    }

    func loadStatuses(user_id: String) {
        let realm = Realm()
        TweetsActions.emitTweets(Array(realm.objects(TweetModel)).map {
            println($0.retweeted_status?.text)
            return $0.toData()
        })
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
