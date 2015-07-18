//
//  AccountData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct AccountData {
    let oauth_token: String
    let oauth_token_secret: String
    let user_id: String
    let screen_name: String
}

extension AccountData: Decodable {

    static func create(oauth_token: String)(oauth_token_secret: String)(user_id: String)(screen_name: String) -> AccountData {
        return AccountData(oauth_token: oauth_token, oauth_token_secret: oauth_token_secret, user_id: user_id, screen_name: screen_name)
    }

    static func decode(j: JSON) -> Decoded<AccountData> {
        return AccountData.create
            <^> j <| "oauth_token"
            <*> j <| "oauth_token_secret"
            <*> j <| "user_id"
            <*> j <| "screen_name"
    }
}
