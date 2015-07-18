//
//  User.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class User: TimestampUtility {

    @NSManaged var account_user_id: String?
    @NSManaged var favourites_count: Int64
    @NSManaged var followers_count: Int64
    @NSManaged var following: Bool
    @NSManaged var friends_count: Int64
    @NSManaged var id_str: String
    @NSManaged var lang: String?
    @NSManaged var listed_count: Int64
    @NSManaged var location: String?
    @NSManaged var name: String
    @NSManaged var profile_image_url: String?
    @NSManaged var screen_name: String
    @NSManaged var statuses_count: Int64
    @NSManaged var time_zone: String?
    @NSManaged var twitter_description: String?
    @NSManaged var unread_count: Int64
    @NSManaged var url: String?
    @NSManaged var utc_offset: Int64
    @NSManaged var verified: Bool

    func toData() -> UserData {
        return UserData()
    }

}
