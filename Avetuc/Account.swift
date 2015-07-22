//
//  Account.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/21/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct Account {
    let user_id: String
    let screen_name: String
    let oauth_token: String
    let oauth_token_secret: String
    let last_fetch_since_id: Int64?
}
