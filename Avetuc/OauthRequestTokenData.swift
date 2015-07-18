//
//  OauthRequestTokenData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/18/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct OauthRequestTokenData {
    let oauth_token: String
    let oauth_token_secret: String
    let oauth_callback_confirmed: Bool
}

extension OauthRequestTokenData: Decodable {

    static func create(oauth_token: String)(oauth_token_secret: String)(oauth_callback_confirmed: String) -> OauthRequestTokenData {
        return OauthRequestTokenData(oauth_token: oauth_token, oauth_token_secret: oauth_token_secret, oauth_callback_confirmed: oauth_callback_confirmed == "true")
    }

//    static func create(oauth_token: String)(oauth_token_secret: String)(oauth_callback_confirmed: Bool) -> OauthRequestTokenData {
//        return OauthRequestTokenData(oauth_token: oauth_token, oauth_token_secret: oauth_token_secret, oauth_callback_confirmed: oauth_callback_confirmed)
//    }

    static func decode(j: JSON) -> Decoded<OauthRequestTokenData> {
        return OauthRequestTokenData.create
            <^> j <| "oauth_token"
            <*> j <| "oauth_token_secret"
            <*> j <| "oauth_callback_confirmed"
    }
}
