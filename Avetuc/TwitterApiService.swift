//
//  TwitterApiService.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/12/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask

typealias BulkProgress = (completedCount: Int, totalCount: Int)
typealias FetchAllFriendsTask = Task<BulkProgress, [[UserApiData]], NSError>

class TwitterApiService {

    static let instance = TwitterApiService()

    private let twitterApi = TwitterApi(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
    private var createUsersTask: CreateUsersTask?

    func loadTokens(#oauthToken: String, oauthTokenSecret: String) {
        self.twitterApi.loadTokens(oauthToken, oauthTokenSecret: oauthTokenSecret)
    }

    func addAccountThroughWeb() {
        self.twitterApi
            .oauthRequestToken([.OauthCallback(TWITTER_OAUTH_CALLBACK)])
            .success { data -> Void in
                self.loadTokens(oauthToken: data.oauth_token, oauthTokenSecret: data.oauth_token_secret)
                let url = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(data.oauth_token)")!
                UIApplication.sharedApplication().openURL(url)
            }
    }

    func handleOauthCallback(url: NSURL) {
        let data = self.twitterApi.parseOauthCallback(url)
        self.twitterApi
            .oauthAccessToken([.OauthVerifier(data.oauth_verifier)])
            .success { data -> CreateAccountTask in
                self.loadTokens(oauthToken: data.oauth_token, oauthTokenSecret: data.oauth_token_secret)
                return LocalStorageService.instance.createAccount(data)
            }
            .success { (data: Account) -> Void in
                emitAccount(data)
            }
    }

    func fetchFriendsOfAccount(user_id: String) {
        self.createUsersTask = self.twitterApi
            .friendsIds([.UserId(user_id), .Count(5000), .StringifyIds(true)])
            .success { data -> FetchAllFriendsTask in
                let ids = data.ids
                var batch = [[String]]()
                var i = 0

                while i < ids.count {
                    let end = min(i + 100, ids.count)
                    batch.append(Array(ids[i..<end]))
                    i += 100
                }

                let tasks = batch.map { (ids: [String]) -> UsersLookupTask in
                    return self.twitterApi.usersLookup([.UserIds(ids), .IncludeEntities(false)])
                }

                return UsersLookupTask.all(tasks)
            }
            .success { (data: [[UserApiData]]) -> CreateUsersTask in
                var result = [UserApiData]()

                for users in data {
                    result += users
                }

                return LocalStorageService.instance.createUsers(result, accountUserId: user_id)
            }

        self.createUsersTask!.success { data -> Void in
            self.createUsersTask = nil
            emitFriends(data)
        }
    }

    // If no since_id is given, get max 200 tweets
    func fetchHomeTimelineOfAccount(user_id: String, since_id: String?)
    {
        var tweetsData: [TweetApiData]?

        getHomeTimeline(self.twitterApi, since_id, nil)
            .success { (data: [TweetApiData]) -> CreateUsersTask in
                if data.count > 0 {
                    tweetsData = data
                    if let createUsersTask = self.createUsersTask {
                        return createUsersTask
                    }
                }
                return CreateUsersTask(value: [])
            }
            .success { (users: [User]) -> Void in
                if let data = tweetsData {
                    LocalStorageService.instance.createTweets(data, account_user_id: user_id)
                    let latest_id = data.first!.id
                    LocalStorageService.instance.updateAccount(user_id, lastest_since_id: latest_id)
                    loadAllFriendsOfAccount(user_id)
                }
            }
    }

}
