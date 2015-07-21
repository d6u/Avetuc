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
typealias StatusesHomeTimelineTask = Task<Float, [TweetData], NSError>

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
                let data: Decoded<OauthRequestTokenData> = decode(json)
                println("oauthRequestToken", data.description)
                return OauthRequestTokenTask(value: data.value!)
            }
    }

    func oauthAccessToken(params: [TwitterApiParam]) -> OauthAccessTokenTask {
        return self.fetch(.OauthAccessToken, params: params)
            .success { (json: AnyObject) -> OauthAccessTokenTask in
                let data: Decoded<AccountData> = decode(json)
                println("oauthAccessToken", data.description)
                return OauthAccessTokenTask(value: data.value!)
        }
    }

    func friendsIds(params: [TwitterApiParam]) -> FriendsIdsTask {
        return self.fetch(.FriendsIds, params: params)
            .success { (json: AnyObject) -> FriendsIdsTask in
                let data: Decoded<FriendsIdsData> = decode(json)
                println("friendsIds", data.description)
                return FriendsIdsTask(value: data.value!)
            }
    }

    func usersLookup(params: [TwitterApiParam]) -> UsersLookupTask {
        return self.fetch(.UsersLookup, params: params)
            .success { (json: AnyObject) -> UsersLookupTask in
                let data: Decoded<[UserData]> = decode(json)
                println("usersLookup", data.description)
                return UsersLookupTask(value: data.value!)
            }
    }

    func statusesHomeTimeline(params: [TwitterApiParam]) -> StatusesHomeTimelineTask {
        return self.fetch(.StatusesHomeTimeline, params: params)
            .success { (json: AnyObject) -> StatusesHomeTimelineTask in
                let data: Decoded<[TweetData]> = decode(json)
                println("statusesHomeTimeline", data.description)
                return StatusesHomeTimelineTask(value: data.value!)
            }
    }

    // MARK: - Callback Handler

    func parseOauthCallback(url: NSURL) -> OauthCallbackData {
        let dict = parseQueryParams(url.query!)
        let callbackData: OauthCallbackData? = decode(dict)
        return callbackData!
    }

}
