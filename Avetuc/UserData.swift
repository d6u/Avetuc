//
//  FriendData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import JSONHelper

struct UserData: Deserializable, TwitterApiResponse {

    var favourites_count: Int64?
    var followers_count: Int64?
    var following: Bool?
    var friends_count: Int64?
    var id_str: String?
    var lang: String?
    var listed_count: Int64?
    var location: String?
    var name: String?
    var profile_image_url: String?
    var screen_name: String?
    var statuses_count: Int64?
    var time_zone: String?
    var twitter_description: String?
    var unread_count: Int64?
    var url: String?
    var utc_offset: Int64?
    var verified: Bool?
    var account_user_id: String?

    init(data: JSONDictionary) {
        favourites_count <-- data["favourites_count"]
        followers_count <-- data["followers_count"]
        following <-- data["following"]
        friends_count <-- data["friends_count"]
        id_str <-- data["id_str"]
        lang <-- data["lang"]
        listed_count <-- data["listed_count"]
        location <-- data["location"]
        name <-- data["name"]
        profile_image_url <-- data["profile_image_url"]
        screen_name <-- data["screen_name"]
        statuses_count <-- data["statuses_count"]
        time_zone <-- data["time_zone"]
        twitter_description <-- data["twitter_description"]
        unread_count <-- data["unread_count"]
        url <-- data["url"]
        utc_offset <-- data["utc_offset"]
        verified <-- data["verified"]
        account_user_id <-- data["account_user_id"]
    }

}
