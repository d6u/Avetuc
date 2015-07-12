//
//  TwitterApiEndpoint.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/12/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

let API_URL = "https://api.twitter.com/1.1/"

enum TwitterApiEndpoint: String {

    case OauthRequestToken = "https://api.twitter.com/oauth/request_token"

    enum Method: String {
        case GET = "GET"
        case POST = "POST"
    }

    var method: String {
        switch self {
        case .OauthRequestToken:
            return Method.POST.rawValue
        }
    }

    var url: String {
        return self.rawValue
    }

    var includeToken: Bool {
        switch self {
        case .OauthRequestToken:
            return false
        default:
            return true
        }
    }
}
