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
    case UserIds([String])
    case ScreenNames([String])
    case IncludeEntities(Bool)

    var pair: (key: String, value: String) {
        switch self {
        case .OauthCallback(let callback):
            return (key: "oauth_callback", value: callback)
        case .OauthVerifier(let verifier):
            return (key: "oauth_verifier", value: verifier)
        case .UserId(let id):
            return (key: "user_id", value: id)
        case .ScreenName(let screen_name):
            return (key: "screen_name", value: screen_name)
        case .StringifyIds(let isTrue):
            return (key: "stringify_ids", value: isTrue ? "true" : "false")
        case .Count(let count):
            return (key: "count", value: String(count))
        case .UserIds(let ids):
            return (key: "user_id", value: join(",", ids))
        case .ScreenNames(let names):
            return (key: "screen_name", value: join(",", names))
        case .IncludeEntities(let isTrue):
            return (key: "include_entities", value: isTrue ? "true" : "false")
        }
    }
}
