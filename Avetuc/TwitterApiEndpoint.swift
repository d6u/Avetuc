//
//  TwitterApiEndpoint.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/12/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

let API_BASE_URL = "https://api.twitter.com/1.1/"
let OAUTH_BASE_URL = "https://api.twitter.com/oauth/"

enum TwitterApiEndpoint: String {

    case OauthRequestToken = "request_token"
    case OauthAccessToken = "access_token"
    case FriendsIds = "friends/ids.json"
    case UsersLookup = "users/lookup.json"
    case StatusesHomeTimeline = "statuses/home_timeline.json"

    enum Method: String {
        case GET = "GET"
        case POST = "POST"
    }

    enum ResponseFormat {
        case QueryParam
        case JSON
    }

    var method: String {
        switch self {
        case .OauthRequestToken: fallthrough
        case .OauthAccessToken:
            return Method.POST.rawValue
        default:
            return Method.GET.rawValue
        }
    }

    var url: String {
        switch self {
        case .OauthRequestToken: fallthrough
        case .OauthAccessToken:
            return OAUTH_BASE_URL + self.rawValue
        default:
            return API_BASE_URL + self.rawValue
        }
    }

    var includeToken: Bool {
        switch self {
        case .OauthRequestToken:
            return false
        default:
            return true
        }
    }

    var responseFormat: ResponseFormat {
        switch self {
        case .OauthAccessToken: fallthrough
        case .OauthRequestToken:
            return .QueryParam
        default:
            return .JSON
        }
    }
}
