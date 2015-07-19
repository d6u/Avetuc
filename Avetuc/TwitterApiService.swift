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

class TwitterApiService {

    class var instance: TwitterApiService {
        struct Static {
            static var instance: TwitterApiService?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = TwitterApiService()
        }
        return Static.instance!
    }

    private let twitterApi = TwitterApi(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)

    func loadTokens(oauthToken: String, oauthTokenSecret: String) {
        self.twitterApi.loadTokens(oauthToken, oauthTokenSecret: oauthTokenSecret)
    }

    func addAccountThroughWeb() {
        self.twitterApi
            .oauthRequestToken([.OauthCallback(TWITTER_OAUTH_CALLBACK)])
            .success { data -> Void in
                self.loadTokens(data.oauth_token, oauthTokenSecret: data.oauth_token_secret)
                let url = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(data.oauth_token)")!
                UIApplication.sharedApplication().openURL(url)
            }
    }

    func handleOauthCallback(url: NSURL) {
        let data = self.twitterApi.parseOauthCallback(url)
        self.twitterApi
            .oauthAccessToken([.OauthVerifier(data.oauth_verifier)])
            .success { data -> CreateAccountTask in
                self.loadTokens(data.oauth_token, oauthTokenSecret: data.oauth_token_secret)
                return LocalStorageService.instance.createAccount(data)
            }
            .success { (data: AccountData) -> Void in
                AccountActions.emitAccount(data)
            }
    }

    func fetchFriends(user_id: String) {
        self.twitterApi
            .friendsIds([.UserId(user_id), .Count(5000), .StringifyIds(true)])
            .success { data -> Task<BulkProgress, [[UserData]], NSError> in
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
            .success { (data: [[UserData]]) -> CreateUsersTask in
                var result = [UserData]()
                for users in data {
                    result += users
                }
                return LocalStorageService.instance.createUsers(result)
            }
            .success { data -> Void in
                FriendActions.emitFriends(data)
            }
    }

}
