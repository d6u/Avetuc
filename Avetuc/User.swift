//
//  User.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData
import Argo

class User: TimestampUtility {

    @NSManaged var favourites_count: Int64
    @NSManaged var followers_count: Int64
    @NSManaged var following: Bool
    @NSManaged var friends_count: Int64
    @NSManaged var id_str: String
    @NSManaged var lang: String
    @NSManaged var listed_count: Int64
    @NSManaged var location: String
    @NSManaged var name: String
    @NSManaged var profile_image_url: String?
    @NSManaged var screen_name: String
    @NSManaged var statuses_count: Int64
    @NSManaged var time_zone: String?
    @NSManaged var url: String?
    @NSManaged var utc_offset: Int64
    @NSManaged var verified: Bool

    // Different name
    @NSManaged var twitter_description: String // Map description

    // Custom
    @NSManaged var unread_count: Int64

    // Relationship
    @NSManaged var profile_account_user_id: String?
    @NSManaged var following_account_user_id: String?

    func toData() -> UserData {
        var dict = self.toDict()
        dict["description"] = dict["twitter_description"]
        let data: UserData? = decode(dict)
        return data!
    }

    func fromData(data: UserData) -> User {
        // Parent class
        self.created_at = data.created_at

        // Different name
        self.twitter_description = data.description

        self.favourites_count = data.favourites_count
        self.followers_count = data.followers_count
        self.following = data.following
        self.friends_count = data.friends_count
        self.id_str = data.id_str
        self.lang = data.lang
        self.listed_count = data.listed_count
        self.location = data.location
        self.name = data.name
        self.profile_image_url = data.profile_image_url
        self.screen_name = data.screen_name
        self.statuses_count = data.statuses_count
        self.time_zone = data.time_zone
        self.unread_count = data.unread_count ?? -1
        self.url = data.url
        self.utc_offset = data.utc_offset ?? 0
        self.verified = data.verified
        self.profile_account_user_id = data.profile_account_user_id
        self.following_account_user_id = data.following_account_user_id

        return self
    }

}
