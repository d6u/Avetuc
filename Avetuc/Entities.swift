//
//  Entities.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/20/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct Entities {
    let hashtags: [Hashtag]?
    let user_mentions: [UserMention]?
    let urls: [Url]?
    let media: [Media]?
}

extension Entities: Decodable {

    static func create
        (hashtags: [Hashtag]?)
        (user_mentions: [UserMention]?)
        (urls: [Url]?)
        (media: [Media]?)-> Entities
    {
        return Entities(hashtags: hashtags, user_mentions: user_mentions, urls: urls, media: media)
    }

    static func decode(j: JSON) -> Decoded<Entities> {
        return Entities.create
            <^> j <||? "hashtags"
            <*> j <||? "user_mentions"
            <*> j <||? "urls"
            <*> j <||? "media"
    }
}
