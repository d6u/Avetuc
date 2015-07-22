//
//  ExtendedEntities.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct ExtendedEntities {
    let media: [ExtendedMediaEntity]
}

extension ExtendedEntities: Decodable {

    static func create(media: [ExtendedMediaEntity])-> ExtendedEntities
    {
        return ExtendedEntities(media: media)
    }

    static func decode(j: JSON) -> Decoded<ExtendedEntities> {
        return ExtendedEntities.create
            <^> j <|| "media"
    }
}
