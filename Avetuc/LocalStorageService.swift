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
import Async

typealias CreateAccountTask = Task<Float, AccountData, NSError>
typealias CreateUsersTask = Task<Float, [UserData], NSError>
typealias CreateTweetsTask = Task<Float, [TweetData], NSError>

class LocalStorageService {

    class var instance: LocalStorageService {
        struct Static {
            static var instance: LocalStorageService?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = LocalStorageService()
        }
        return Static.instance!
    }

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
            self.dataStack.beginAsynchronous { transaction in
                let account = transaction.create(Into(Account)).fromData(accountData)

                transaction.commit { result -> Void in
                    switch result {
                    case .Success(let hasChanges):
                        println("success! hasChanges? \(hasChanges)")
                        Async.main {
                            fulfill(accountData)
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
        dataStack.beginAsynchronous {(transaction) in
            let accounts = transaction.fetchAll(From(Account))!

            if let account = accounts.first {
                let accountData = account.toData()
                Async.main {
                    TwitterApiService.instance.loadTokens(accountData.oauth_token!, oauthTokenSecret: accountData.oauth_token_secret!)
                    AccountActions.emitAccount(accountData)
                }
            } else {
                Async.main {
                    AccountActions.emitAccount(nil)
                }
            }
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
        self.dataStack.beginAsynchronous { transaction in
            let account = transaction.fetchOne(From(Account), Where("user_id == %@", user_id))!
            account.last_fetch_since_id = latest_id
            transaction.commit()
        }
    }

}
