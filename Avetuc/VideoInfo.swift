//
//  VideoInfo.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct VideoInfo {
    let aspect_ratio: [Int]
    let variants: [VideoInfoVariant]
}

extension VideoInfo: Decodable {

    static func create
        (aspect_ratio: [Int])
        (variants: [VideoInfoVariant]) -> VideoInfo
    {
        return VideoInfo(aspect_ratio: aspect_ratio, variants: variants)
    }

    static func decode(j: JSON) -> Decoded<VideoInfo> {
        return VideoInfo.create
            <^> j <|| "aspect_ratio"
            <*> j <|| "variants"
    }
}
