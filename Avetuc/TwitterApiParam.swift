//
//  TwitterApiParam.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/12/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

enum TwitterApiParam {

    case OauthCallback(String)
    case OauthVerifier(String)
    case UserId(String)
    case ScreenName(String)
    case StringifyIds(Bool)
    case Count(Int16)

    var keyValuePair: (String, String) {
        switch self {
        case .OauthCallback(let value):
            return ("oauth_callback", value)
        case .OauthVerifier(let value):
            return ("oauth_verifier", value)
        case .UserId(let value):
            return ("user_id", value)
        case .ScreenName(let value):
            return ("screen_name", value)
        case .StringifyIds(let value):
            return ("stringify_ids", value ? "true" : "false")
        case .Count(let value):
            return ("count", String(value))
        }
    }
}
