
//  Tweet.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RealmSwift

class TweetModel: Object {

    override static func indexedProperties() -> [String] {
        return ["id"]
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    dynamic var created_at: String = ""
    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""
    dynamic var text: String = ""
    dynamic var source: String = ""
    dynamic var truncated: Bool = false
    dynamic var in_reply_to_status_id: Int64 = -1
    dynamic var in_reply_to_status_id_str: String = ""
    dynamic var in_reply_to_user_id: Int64 = -1
    dynamic var in_reply_to_user_id_str: String = ""
    dynamic var in_reply_to_screen_name: String = ""
    // dynamic var geo: Coordinates? = ""
    // dynamic var coordinates: Coordinates? = ""
    // dynamic var place: Place? = ""
    dynamic var retweet_count: Int64 = -1
    dynamic var favorite_count: Int64 = -1
    dynamic var favorited: Bool = false
    dynamic var retweeted: Bool = false
    dynamic var possibly_sensitive: Bool = false
    dynamic var possibly_sensitive_appealable: Bool = false
    dynamic var lang: String = ""

    dynamic var retweeted_status: TweetModel?
    let hashtag_entities = List<HashtagEntityModel>()
    let url_entities = List<UrlEntityModel>()
    let user_mention_entities = List<UserMentionEntityModel>()
    let media_entities = List<MediaEntityModel>()
    let extended_media_entities = List<ExtendedMediaEntityModel>()

    var user: UserModel? {
        return (self.linkingObjects(UserModel.self, forProperty: "statuses") as [UserModel]).first
    }

    func fromApiData(data: TweetApiData) -> TweetModel {
        self.created_at = data.created_at
        self.id = data.id
        self.id_str = data.id_str
        self.text = data.text
        self.source = data.source
        self.truncated = data.truncated
        self.in_reply_to_status_id = data.in_reply_to_status_id ?? -1
        self.in_reply_to_status_id_str = data.in_reply_to_status_id_str ?? ""
        self.in_reply_to_user_id = data.in_reply_to_user_id ?? -1
        self.in_reply_to_user_id_str = data.in_reply_to_user_id_str ?? ""
        self.in_reply_to_screen_name = data.in_reply_to_screen_name ?? ""
        self.retweet_count = data.retweet_count
        self.favorite_count = data.favorite_count
        self.favorited = data.favorited
        self.retweeted = data.retweeted
        self.possibly_sensitive = data.possibly_sensitive ?? false
        self.possibly_sensitive_appealable = data.possibly_sensitive_appealable ?? false
        self.lang = data.lang
        return self
    }

    func toData() -> Tweet {
        return Tweet(
            created_at: created_at,
            id: id,
            id_str: id_str,
            text: text,
            source: source,
            truncated: truncated,
            in_reply_to_status_id: in_reply_to_status_id == -1 ? nil : in_reply_to_status_id,
            in_reply_to_status_id_str: in_reply_to_status_id_str == "" ? nil : in_reply_to_status_id_str,
            in_reply_to_user_id: in_reply_to_user_id == -1 ? nil : in_reply_to_user_id,
            in_reply_to_user_id_str: in_reply_to_user_id_str == "" ? nil : in_reply_to_user_id_str,
            in_reply_to_screen_name: in_reply_to_screen_name == "" ? nil : in_reply_to_screen_name,
            retweet_count: retweet_count,
            favorite_count: favorite_count,
            favorited: favorited,
            retweeted: retweeted,
            possibly_sensitive: possibly_sensitive,
            possibly_sensitive_appealable: possibly_sensitive_appealable,
            lang: lang
        )
    }

}
