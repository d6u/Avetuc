//
//  Media.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/21/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct Media {
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
    let source_status_id: Int64
    let source_status_id_str: String
    let source_user_id: Int64
    let source_user_id_str: String
}

extension Media: Decodable {

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
        (source_status_id: Int64)
        (source_status_id_str: String)
        (source_user_id: Int64)
        (source_user_id_str: String) -> Media
    {
        return Media(id: id, id_str: id_str, indices: indices, media_url: media_url, media_url_https: media_url_https, url: url, display_url: display_url, expanded_url: expanded_url, type: type, sizes: sizes, source_status_id: source_status_id, source_status_id_str: source_status_id_str, source_user_id: source_user_id, source_user_id_str: source_user_id_str)
    }

    static func decode(j: JSON) -> Decoded<Media> {

        // Have to breakup decode into multiple chunk and use type cast,
        // because Swift compiler cannot handle such complex expression ¯\_(ツ)_/¯
        typealias Halved = Decoded<String -> String -> Size -> Int64 -> String -> Int64 -> String -> Media>

        let p: Halved = Media.create
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
            <*> j <| "source_status_id"
            <*> j <| "source_status_id_str"
            <*> j <| "source_user_id"
            <*> j <| "source_user_id_str"
    }
}
