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
    let account_identifier: String?
    let last_fetch_since_id: String?
    let oauth_token: String?
    let oauth_token_secret: String?
    let user_id: String
    let screen_name: String
}

extension AccountData: Decodable {

    static func create(account_identifier: String?)(last_fetch_since_id: String?)(oauth_token: String?)(oauth_token_secret: String?)(user_id: String)(screen_name: String) -> AccountData {
        return AccountData(account_identifier: account_identifier, last_fetch_since_id: last_fetch_since_id, oauth_token: oauth_token, oauth_token_secret: oauth_token_secret, user_id: user_id, screen_name: screen_name)
    }

    static func decode(j: JSON) -> Decoded<AccountData> {
        return AccountData.create
            <^> j <|? "account_identifier"
            <*> j <|? "last_fetch_since_id"
            <*> j <|? "oauth_token"
            <*> j <|? "oauth_token_secret"
            <*> j <| "user_id"
            <*> j <| "screen_name"
    }
}
