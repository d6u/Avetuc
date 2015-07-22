//
//  VideoInfoVariant.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct VideoInfoVariant {
    let bitrate: Int64
    let content_type: String
    let url: String
}

extension VideoInfoVariant: Decodable {

    static func create
        (bitrate: Int64)
        (content_type: String)
        (url: String) -> VideoInfoVariant
    {
        return VideoInfoVariant(
            bitrate: bitrate,
            content_type: content_type,
            url: url
        )
    }

    static func decode(j: JSON) -> Decoded<VideoInfoVariant> {
        return VideoInfoVariant.create
            <^> j <| "bitrate"
            <*> j <| "content_type"
            <*> j <| "url"
    }
}
