//
//  Entity.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/20/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct Hashtag {
    let text: String
    let indices: [Int64]
}

extension Hashtag: Decodable {

    static func create
        (text: String)
        (indices: [Int64]) -> Hashtag
    {
        return Hashtag(text: text, indices: indices)
    }

    static func decode(j: JSON) -> Decoded<Hashtag> {
        return Hashtag.create
            <^> j <|  "text"
            <*> j <|| "indices"
    }
}
