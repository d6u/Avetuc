//
//  FriendsIdsData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/17/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import JSONHelper

struct FriendsIdsData: Deserializable, TwitterApiResponse {

    var ids: [String]?
    var previous_cursor_str: String?
    var next_cursor_str: String?

    init(data: JSONDictionary) {
        ids <-- data["ids"]
        previous_cursor_str <-- data["previous_cursor_str"]
        next_cursor_str <-- data["next_cursor_str"]
    }
}
