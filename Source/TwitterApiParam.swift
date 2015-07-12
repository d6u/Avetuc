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

    var keyValuePair: (String, String) {
        switch self {
        case .OauthCallback(let value):
            return ("oauth_callback", value)
        }
    }
}
