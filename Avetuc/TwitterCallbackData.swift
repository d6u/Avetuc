//
//  TwitterCallbackData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/14/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import JSONHelper

struct TwitterCallbackData: Deserializable {
    var oauth_token: String?
    var oauth_verifier: String?

    init(data: JSONDictionary) {
        oauth_token <-- data["oauth_token"]
        oauth_verifier <-- data["oauth_verifier"]
    }
}
