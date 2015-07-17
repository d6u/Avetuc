//
//  AccountData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import JSONHelper

struct AccountData: Deserializable, TwitterApiResponse {

    var oauth_token: String?
    var oauth_token_secret: String?
    var user_id: String?
    var screen_name: String?

    init(data: JSONDictionary) {
        oauth_token <-- data["oauth_token"]
        oauth_token_secret <-- data["oauth_token_secret"]
        user_id <-- data["user_id"]
        screen_name <-- data["screen_name"]
    }

}
