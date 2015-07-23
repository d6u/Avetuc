//
//  UserMention.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/21/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct UserMention {
    let screen_name: String
    let name: String
    let id: Int64
    let id_str: String
    let indices: [Int64]
}

extension UserMention: Decodable {

    static func create
        (screen_name: String)
        (name: String)
        (id: Int64)
        (id_str: String)
        (indices: [Int64]
    ) -> UserMention
    {
        return UserMention(screen_name: screen_name, name: name, id: id, id_str: id_str, indices: indices)
    }

    static func decode(j: JSON) -> Decoded<UserMention> {
        return UserMention.create
            <^> j <|  "screen_name"
            <*> j <| "name"
            <*> j <| "id"
            <*> j <| "id_str"
            <*> j <|| "indices"
    }
}
