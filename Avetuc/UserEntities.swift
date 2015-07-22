//
//  UserEntities.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/21/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct UserEntities {
    let url: UserEntity?
    let description: UserEntity
}

extension UserEntities: Decodable {

    static func create
        (url: UserEntity?)
        (description: UserEntity)
        -> UserEntities
    {
        return UserEntities(url: url, description: description)
    }

    static func decode(j: JSON) -> Decoded<UserEntities> {
        return UserEntities.create
            <^> j <|? "url"
            <*> j <| "description"
    }
}
