
//  Tweet.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RealmSwift

class TweetModel: Object {

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

}
