//
//  TweetData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct TweetData {
    let created_at: String
    let favorite_count: Int64
    let favorited: Bool
    let id_str: String
    let in_reply_to_screen_name: String?
    let in_reply_to_status_id_str: String?
    let in_reply_to_user_id_str: String?
    let is_read: Bool?
    let lang: String?
    let retweet_count: Int64
    let retweeted: Bool
    let text: String
    let text_with_entities: String?
    let creator_user_id: String
    let retweeted_tweet_id: String?
    let quoted_tweet_id: String?
    let master_account_user_id: String?
}

extension TweetData: Decodable {

    static func create(created_at: String)(favorite_count: Int64)(favorited: Bool)(id_str: String)(in_reply_to_screen_name: String?)(in_reply_to_status_id_str: String?)(in_reply_to_user_id_str: String?)(is_read: Bool?)(lang: String?)(retweet_count: Int64)(retweeted: Bool)(text: String)(text_with_entities: String?)(creator_user_id: String)(retweeted_tweet_id: String?)(quoted_tweet_id: String?)(master_account_user_id: String?) -> TweetData
    {
        return TweetData(created_at: created_at, favorite_count: favorite_count, favorited: favorited, id_str: id_str, in_reply_to_screen_name: in_reply_to_screen_name, in_reply_to_status_id_str: in_reply_to_status_id_str, in_reply_to_user_id_str: in_reply_to_user_id_str, is_read: is_read, lang: lang, retweet_count: retweet_count, retweeted: retweeted, text: text, text_with_entities: text_with_entities, creator_user_id: creator_user_id, retweeted_tweet_id: retweeted_tweet_id, quoted_tweet_id: quoted_tweet_id, master_account_user_id: master_account_user_id)
    }

    static func decode(j: JSON) -> Decoded<TweetData> {

        // Have to breakup decode into multiple chunk and use type cast,
        // because Swift compiler cannot handle such complex expression ¯\_(ツ)_/¯
        typealias Halved = Decoded<Int64 -> Bool -> String -> String? -> String -> String? -> String? -> String? -> TweetData>

        let f: Halved = TweetData.create
            <^> j <| "created_at"
            <*> j <| "favorite_count"
            <*> j <| "favorited"
            <*> j <| "id_str"
            <*> j <|? "in_reply_to_screen_name"
            <*> j <|? "in_reply_to_status_id_str"
            <*> j <|? "in_reply_to_user_id_str"
            <*> j <|? "is_read"
            <*> j <|? "lang"

        return f
            <*> j <| "retweet_count"
            <*> j <| "retweeted"
            <*> j <| "text"
            <*> j <|? "text_with_entities"
            <*> j <| ["user", "id_str"]
            <*> j <|? "retweeted_tweet_id"
            <*> j <|? "quoted_tweet_id"
            <*> j <|? "master_account_user_id"
    }
}
