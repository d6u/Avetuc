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
typealias OauthAccessTokenTask = Task<Float, AccountApiData, NSError>
typealias FriendsIdsTask = Task<Float, FriendsIdsData, NSError>
typealias UsersLookupTask = Task<Float, [UserApiData], NSError>
typealias StatusesHomeTimelineTask = Task<Float, [TweetApiData], NSError>

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
                if let d = data.value {
                    return OauthRequestTokenTask(value: d)
                } else {
                    let err = parseError(.OauthRequestToken, data)
                    println("oauthRequestToken", err)
                    return OauthRequestTokenTask(error: err)
                }
            }
    }

    func oauthAccessToken(params: [TwitterApiParam]) -> OauthAccessTokenTask {
        return self.fetch(.OauthAccessToken, params: params)
            .success { (json: AnyObject) -> OauthAccessTokenTask in
                let data: Decoded<AccountApiData> = decode(json)
                println("oauthAccessToken", data.description)
                return OauthAccessTokenTask(value: data.value!)
        }
    }

    func friendsIds(params: [TwitterApiParam]) -> FriendsIdsTask {
        return self.fetch(.FriendsIds, params: params)
            .success { (json: AnyObject) -> FriendsIdsTask in
                let data: Decoded<FriendsIdsData> = decode(json)
                if let d = data.value {
                    return FriendsIdsTask(value: d)
                } else {
                    let err = parseError(.FriendsIds, data)
                    println("friendsIds", err)
                    return FriendsIdsTask(error: err)
                }
            }
    }

    func usersLookup(params: [TwitterApiParam]) -> UsersLookupTask {
        return self.fetch(.UsersLookup, params: params)
            .success { (json: AnyObject) -> UsersLookupTask in
                let data: Decoded<[UserApiData]> = decode(json)
                if let d = data.value {
                    return UsersLookupTask(value: d)
                } else {
                    let err = parseError(.UsersLookup, data)
                    println("usersLookup", err)
                    return UsersLookupTask(error: err)
                }
            }
    }

    func statusesHomeTimeline(params: [TwitterApiParam]) -> StatusesHomeTimelineTask {
        return self.fetch(.StatusesHomeTimeline, params: params)
            .success { (json: AnyObject) -> StatusesHomeTimelineTask in
                let data: Decoded<[TweetApiData]> = decode(json)
                if let value = data.value {
                    return StatusesHomeTimelineTask(value: value)
                } else {
                    let err = parseError(.StatusesHomeTimeline, data)
                    println("statusesHomeTimeline", err)
                    return StatusesHomeTimelineTask(error: err)
                }
            }
    }

}
