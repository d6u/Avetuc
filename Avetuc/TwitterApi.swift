//
//  TwitterApi.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/18/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask
import Argo

typealias OauthRequestTokenTask = Task<Float, OauthRequestTokenData, NSError>
typealias OauthAccessTokenTask = Task<Float, AccountData, NSError>
typealias FriendsIdsTask = Task<Float, FriendsIdsData, NSError>
typealias UsersLookupTask = Task<Float, [UserData], NSError>

class TwitterApi {

    init(consumerKey: String, consumerSecret: String) {
        self.client = TwitterApiClient(consumerKey: consumerKey, consumerSecret: consumerSecret)
    }

    private let client: TwitterApiClient

    func loadTokens(oauthToken: String, oauthTokenSecret: String) {
        self.client.loadTokens(oauthToken, oauthTokenSecret: oauthTokenSecret)
    }

    private func fetch(endpoint: TwitterApiEndpoint, params: [TwitterApiParam]) -> FetchTask {
        return self.client.fetch(endpoint, params: params)
    }

    // MARK: - API

    func oauthRequestToken(params: [TwitterApiParam]) -> OauthRequestTokenTask {
        return self.fetch(.OauthRequestToken, params: params)
            .success { (json: AnyObject) -> OauthRequestTokenTask in
                let data: OauthRequestTokenData? = decode(json)
                return OauthRequestTokenTask(value: data!)
            }
    }

    func oauthAccessToken(params: [TwitterApiParam]) -> OauthAccessTokenTask {
        return self.fetch(.OauthAccessToken, params: params)
            .success { (json: AnyObject) -> OauthAccessTokenTask in
                let data: AccountData? = decode(json)
                return OauthAccessTokenTask(value: data!)
        }
    }

    func friendsIds(params: [TwitterApiParam]) -> FriendsIdsTask {
        return self.fetch(.FriendsIds, params: params)
            .success { (json: AnyObject) -> FriendsIdsTask in
                let data: FriendsIdsData? = decode(json)
                return FriendsIdsTask(value: data!)
            }
    }

    func usersLookup(params: [TwitterApiParam]) -> UsersLookupTask {
        return self.fetch(.UsersLookup, params: params)
            .success { (json: AnyObject) -> UsersLookupTask in
                let data: [UserData]? = decode(json)
                return UsersLookupTask(value: data!)
            }
    }

    // MARK: - Callback Handler

    func parseOauthCallback(url: NSURL) -> OauthCallbackData {
        let dict = parseQueryParams(url.query!)
        let callbackData: OauthCallbackData? = decode(dict)
        return callbackData!
    }

}
