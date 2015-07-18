//
//  FriendsIdsData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/17/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct FriendsIdsData {
    let ids: [String]
    let previous_cursor: Int64
    let next_cursor: Int64
}

extension FriendsIdsData: Decodable {

    static func create(ids: [String])(previous_cursor: Int64)(next_cursor: Int64) -> FriendsIdsData {
        return FriendsIdsData(ids: ids, previous_cursor: previous_cursor, next_cursor: next_cursor)
    }

    static func decode(j: JSON) -> Decoded<FriendsIdsData> {
        return FriendsIdsData.create
            <^> j <|| "ids"
            <*> j <| "previous_cursor"
            <*> j <| "next_cursor"
    }
}
