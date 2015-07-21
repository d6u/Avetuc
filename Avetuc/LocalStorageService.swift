//
//  LocalStoreService.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreStore
import SwiftTask
import RealmSwift
import Async

typealias CreateAccountTask = Task<Float, AccountData, NSError>
typealias CreateUsersTask = Task<Float, [UserData], NSError>
typealias CreateTweetsTask = Task<Float, [TweetData], NSError>

class LocalStorageService {

    static let instance = LocalStorageService()

    let dataStack: DataStack

    init() {
        dataStack = DataStack(modelName: "Avetuc")

        switch dataStack.addSQLiteStoreAndWait(
            "Avetuc.sqlite",
            configuration: "Default",
            automigrating: true,
            resetStoreOnMigrationFailure: true)
        {
        case .Success(let persistentStore):
            println("Successfully created an sqlite store: \(persistentStore)")
        case .Failure(let error):
            println("Failed creating an sqlite store with error :\(error.description)")
        }
    }

    // MARK: Create

    func createAccount(accountData: AccountData) -> CreateAccountTask {
        return CreateAccountTask { progress, fulfill, reject, configure in
            let realm = Realm()

            let account = Account()
            account.oauth_token = accountData.oauth_token!
            account.oauth_token_secret = accountData.oauth_token_secret!
            account.user_id = accountData.user_id
            account.screen_name = accountData.screen_name

            realm.write {
                realm.add(account, update: true)
            }

            fulfill(accountData)
        }
    }

    func createUsers(
        usersData: [UserData],
        following_account_user_id: String? = nil,
        profile_account_user_id: String? = nil
    ) -> CreateUsersTask
    {
        return CreateUsersTask { progress, fulfill, reject, configure in
            self.dataStack.beginAsynchronous { transaction in

                let users = usersData.map { data -> User in
                    var user: User! = transaction.fetchOne(From(User), Where("id_str == %@", data.id_str))

                    if let user = user {
                        user.fromData(data)
                    } else {
                        user = transaction.create(Into(User)).fromData(data)
                    }

                    // TODO: Improve fromData() method, prevent some property from updating
                    user.following_account_user_id = following_account_user_id
                    user.profile_account_user_id = profile_account_user_id

                    return user
                }

                transaction.commit { result -> Void in
                    switch result {
                    case .Success(let hasChanges):
                        println("success! hasChanges? \(hasChanges)")
                        let data = users.map { $0.toData() }
                        Async.main {
                            fulfill(data)
                        }
                    case .Failure(let error):
                        println(error)
                        Async.main {
                            reject(error)
                        }
                    }
                }
            }
        }
    }

    func createTweets(
        tweetsData: [TweetData],
        master_account_user_id: String,
        retweeted_tweet_id: String? = nil,
        quoted_tweet_id: String? = nil
    ) -> CreateTweetsTask
    {
        return CreateTweetsTask { progress, fulfill, reject, configure in
            self.dataStack.beginAsynchronous { transaction in

                let tweets = tweetsData.map { data -> Tweet in
                    var tweet: Tweet! = transaction.create(Into(Tweet)).fromData(data)

                    tweet.creator_user_id = data.creator_user_id
                    tweet.master_account_user_id = master_account_user_id
                    tweet.retweeted_tweet_id = retweeted_tweet_id
                    tweet.quoted_tweet_id = quoted_tweet_id

                    return tweet
                }

                transaction.commit { result -> Void in
                    switch result {
                    case .Success(let hasChanges):
                        println("Tweets created! hasChanges? \(hasChanges)")
                        let data = tweets.map { $0.toData() }
                        Async.main {
                            fulfill(data)
                        }
                    case .Failure(let error):
                        println(error)
                        Async.main {
                            reject(error)
                        }
                    }
                }
            }
        }
    }

    // MARK: Read

    func loadDefaultAccount() {
        let realm = Realm()
        if let account = realm.objects(Account).first {
            let accountData = account.toData()
            TwitterApiService.instance.loadTokens(accountData.oauth_token!, oauthTokenSecret: accountData.oauth_token_secret!)
            AccountActions.emitAccount(accountData)
        } else {
            AccountActions.emitAccount(nil)
        }
    }

    func loadFriendsFor(user_id: String) {
        self.dataStack.beginAsynchronous { transaction in
            let users = transaction.fetchAll(From(User), Where("following_account_user_id == %@", user_id))!
            let data = users.map { $0.toData() }
            Async.main {
                FriendActions.emitFriends(data)
            }
        }
    }

    func loadStatuses(user_id: String) {
        self.dataStack.beginAsynchronous { (transaction) -> Void in
            let tweets = transaction.fetchAll(From(Tweet), Where("creator_user_id == %@", user_id))!
            let data = tweets.map { $0.toData() }
            Async.main {
                TweetsActions.emitTweets(data)
            }
        }
    }

    // Mark: - Update

    func updateAccountLastestSinceId(user_id: String, latest_id: String) {
        let realm = Realm()
        let account = realm.objects(Account).filter("user_id == %@", user_id).first!

        realm.write {
            account.last_fetch_since_id = latest_id
        }
    }

}
