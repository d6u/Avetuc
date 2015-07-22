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
//typealias CreateTweetsTask = Task<Float, [TweetData], NSError>

class LocalStorageService {

    static let instance = LocalStorageService()

    init() {
    }

    // MARK: Create

    func createAccount(data: AccountApiData) -> CreateAccountTask {
        return CreateAccountTask { progress, fulfill, reject, configure in
            let realm = Realm()

            let model = AccountModel()
            model.oauth_token = data.oauth_token
            model.oauth_token_secret = data.oauth_token_secret
            model.user_id = data.user_id
            model.screen_name = data.screen_name

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

            let users = usersData.map { data -> UserModel in

                let model = UserModel()
                model.id = data.id
                model.id_str = data.id_str
                model.name = data.name!
                model.screen_name = data.screen_name
                model.location = data.location
                model.t_description = data.description
                model.url = data.url ?? ""
                model.protected = data.protected
                model.followers_count = data.followers_count
                model.friends_count = data.friends_count
                model.listed_count = data.listed_count
                model.created_at = data.created_at
                model.favourites_count = data.favourites_count
                model.utc_offset = data.utc_offset ?? -1
                model.time_zone = data.time_zone ?? ""
                model.verified = data.verified
                model.statuses_count = data.statuses_count
                model.lang = data.lang
                model.profile_background_color = data.profile_background_color
                model.profile_background_image_url = data.profile_background_image_url
                model.profile_background_image_url_https = data.profile_background_image_url_https
                model.profile_image_url = data.profile_image_url
                model.profile_image_url_https = data.profile_image_url_https
                model.profile_link_color = data.profile_link_color
                model.profile_text_color = data.profile_text_color
                model.profile_use_background_image = data.profile_use_background_image
                model.default_profile = data.default_profile
                model.default_profile_image = data.default_profile_image
                model.following = data.following
                model.follow_request_sent = data.follow_request_sent
                model.notifications = data.notifications
                model.profile_banner_url = data.profile_banner_url ?? ""

                return model
            }

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
//
//    func createTweets(
//        tweetsData: [TweetData],
//        master_account_user_id: String,
//        retweeted_tweet_id: String? = nil,
//        quoted_tweet_id: String? = nil
//    ) -> CreateTweetsTask
//    {
//        return CreateTweetsTask { progress, fulfill, reject, configure in
//            self.dataStack.beginAsynchronous { transaction in
//
//                let tweets = tweetsData.map { data -> Tweet in
//                    var tweet: Tweet! = transaction.create(Into(Tweet)).fromData(data)
//
//                    tweet.creator_user_id = data.creator_user_id
//                    tweet.master_account_user_id = master_account_user_id
//                    tweet.retweeted_tweet_id = retweeted_tweet_id
//                    tweet.quoted_tweet_id = quoted_tweet_id
//
//                    return tweet
//                }
//
//                transaction.commit { result -> Void in
//                    switch result {
//                    case .Success(let hasChanges):
//                        println("Tweets created! hasChanges? \(hasChanges)")
//                        let data = tweets.map { $0.toData() }
//                        Async.main {
//                            fulfill(data)
//                        }
//                    case .Failure(let error):
//                        println(error)
//                        Async.main {
//                            reject(error)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
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
//
//    func loadStatuses(user_id: String) {
//        self.dataStack.beginAsynchronous { (transaction) -> Void in
//            let tweets = transaction.fetchAll(From(Tweet), Where("creator_user_id == %@", user_id))!
//            let data = tweets.map { $0.toData() }
//            Async.main {
//                TweetsActions.emitTweets(data)
//            }
//        }
//    }
//
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
