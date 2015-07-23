//
//  ExtendedMediaEntity.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct ExtendedMediaEntity {
    let id: Int64
    let id_str: String
    let indices: [Int64]
    let media_url: String
    let media_url_https: String
    let url: String
    let display_url: String
    let expanded_url: String
    let type: String
    let sizes: Size
    let video_info: VideoInfo?
}

extension ExtendedMediaEntity: Decodable {

    static func create
        (id: Int64)
        (id_str: String)
        (indices: [Int64])
        (media_url: String)
        (media_url_https: String)
        (url: String)
        (display_url: String)
        (expanded_url: String)
        (type: String)
        (sizes: Size)
        (video_info: VideoInfo?) -> ExtendedMediaEntity
    {
        return ExtendedMediaEntity(
            id: id,
            id_str: id_str,
            indices: indices,
            media_url: media_url,
            media_url_https: media_url_https,
            url: url,
            display_url: display_url,
            expanded_url: expanded_url,
            type: type,
            sizes: sizes,
            video_info: video_info
        )
    }

    static func decode(j: JSON) -> Decoded<ExtendedMediaEntity> {

        // Have to breakup decode into multiple chunk and use type cast,
        // because Swift compiler cannot handle such complex expression ¯\_(ツ)_/¯
        typealias Halved = Decoded<String -> String -> Size -> VideoInfo? -> ExtendedMediaEntity>

        let p: Halved = ExtendedMediaEntity.create
            <^> j <| "id"
            <*> j <| "id_str"
            <*> j <|| "indices"
            <*> j <| "media_url"
            <*> j <| "media_url_https"
            <*> j <| "url"
            <*> j <| "display_url"

        return p
            <*> j <| "expanded_url"
            <*> j <| "type"
            <*> j <| "sizes"
            <*> j <|? "video_info"
    }
}
