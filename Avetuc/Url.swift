//
//  Url.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/21/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct Url {
    let url: String
    let expanded_url: String
    let display_url: String
    let indices: [Int64]
}

extension Url: Decodable {

    static func create
        (url: String)
        (expanded_url: String)
        (display_url: String)
        (indices: [Int64]) -> Url
    {
        return Url(url: url, expanded_url: expanded_url, display_url: display_url, indices: indices)
    }

    static func decode(j: JSON) -> Decoded<Url> {
        return Url.create
            <^> j <| "url"
            <*> j <| "expanded_url"
            <*> j <| "display_url"
            <*> j <|| "indices"
    }
}
