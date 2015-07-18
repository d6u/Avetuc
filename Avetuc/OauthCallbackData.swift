//
//  TwitterCallbackData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/14/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct OauthCallbackData {
    let oauth_token: String
    let oauth_verifier: String
}

extension OauthCallbackData: Decodable {

    static func create(oauth_token: String)(oauth_verifier: String) -> OauthCallbackData {
        return OauthCallbackData(oauth_token: oauth_token, oauth_verifier: oauth_verifier)
    }

    static func decode(j: JSON) -> Decoded<OauthCallbackData> {
        return OauthCallbackData.create
            <^> j <| "oauth_token"
            <*> j <| "oauth_verifier"
    }
}
