//
//  Tweet.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class Tweet: TimestampUtility {

    @NSManaged var favorite_count: Int64
    @NSManaged var favorited: Bool
    @NSManaged var in_reply_to_screen_name: String
    @NSManaged var in_reply_to_status_id_str: String
    @NSManaged var in_reply_to_user_id_str: String
    @NSManaged var isRead: Bool
    @NSManaged var lang: String
    @NSManaged var text_with_entities: String
    @NSManaged var retweet_count: Int64
    @NSManaged var retweeted: Bool
    @NSManaged var text: String
    @NSManaged var id_str: String
    @NSManaged var entities: NSSet
    @NSManaged var quotedStatus: Tweet
    @NSManaged var quotingStatus: NSSet
    @NSManaged var relatedAccount: Account
    @NSManaged var retweetedStatus: Tweet
    @NSManaged var retweetingStatus: NSSet
    @NSManaged var user: User

    // TODO: Move to Tweet class
    //                // "description" is reserved property
    //                let propertyName = key == "description" ? "twitterDescription" : key

}
