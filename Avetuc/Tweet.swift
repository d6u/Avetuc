//
//  Tweet.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct Tweet {

    let created_at: String
    let id: Int64
    let id_str: String
    let text: String
    let source: String
    let truncated: Bool
    let in_reply_to_status_id: Int64?
    let in_reply_to_status_id_str: String?
    let in_reply_to_user_id: Int64?
    let in_reply_to_user_id_str: String?
    let in_reply_to_screen_name: String?
    let retweet_count: Int64
    let favorite_count: Int64
    let favorited: Bool
    let retweeted: Bool
    let possibly_sensitive: Bool
    let possibly_sensitive_appealable: Bool
    let lang: String

    let hashtags: [Hashtag]
    let urls: [Url]
    let user_mentions: [UserMention]
    let medias: [Media]
    let extended_medias: [ExtendedMedia]

}
