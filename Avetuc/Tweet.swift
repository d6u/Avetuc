
//  Tweet.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData
import Argo

//class Tweet: TimestampUtility {
//
//    @NSManaged var favorite_count: Int64
//    @NSManaged var favorited: Bool
//    @NSManaged var id_str: String
//    @NSManaged var in_reply_to_screen_name: String?
//    @NSManaged var in_reply_to_status_id_str: String?
//    @NSManaged var in_reply_to_user_id_str: String?
//    @NSManaged var lang: String?
//    @NSManaged var retweet_count: Int64
//    @NSManaged var retweeted: Bool
//    @NSManaged var text: String
//
//    // Customized
//    @NSManaged var is_read: Bool
//    @NSManaged var text_with_entities: String?
//
//    // Relationships
//    @NSManaged var master_account_user_id: String
//    @NSManaged var creator_user_id: String
//    @NSManaged var retweeted_tweet_id: String?
//    @NSManaged var quoted_tweet_id: String?
//
//    func toData() -> TweetData {
//        var dict = self.toDict()
//        let data: TweetData? = decode(dict)
//        return data!
//    }
//
//    func fromData(data: TweetData) -> Tweet {
//
//        // Parent class
//        self.created_at = data.created_at
//
//        self.favorite_count = data.favorite_count
//        self.favorited = data.favorited
//        self.id_str = data.id_str
//        self.in_reply_to_screen_name = data.in_reply_to_screen_name
//        self.in_reply_to_status_id_str = data.in_reply_to_status_id_str
//        self.in_reply_to_user_id_str = data.in_reply_to_user_id_str
//        self.lang = data.lang
//        self.retweet_count = data.retweet_count
//        self.retweeted = data.retweeted
//        self.text = data.text
//
//        return self
//    }
//
//}
