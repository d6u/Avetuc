//
//  TokenData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/14/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct TokenData: TwitterApiResponse {
    let oauth_token: String
    let oauth_token_secret: String
    let oauth_callback_confirmed: Bool
}
