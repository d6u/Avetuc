//
//  UserUrlEntity.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/21/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct UserEntity {
    let urls: [Url]
}

extension UserEntity: Decodable {

    static func create
        (urls: [Url])
        -> UserEntity
    {
        return UserEntity(urls: urls)
    }

    static func decode(j: JSON) -> Decoded<UserEntity> {
        return UserEntity.create
            <^> j <|| "urls"
    }
}
