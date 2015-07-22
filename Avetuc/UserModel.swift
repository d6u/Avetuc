//
//  User.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {

    override static func indexedProperties() -> [String] {
        return ["id"]
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""
    dynamic var name: String = ""
    dynamic var screen_name: String = ""
    dynamic var location: String = ""
    dynamic var t_description: String = ""
    dynamic var url: String = ""
    // dynamic var entities: UserEntities = // TODO
    dynamic var protected: Bool = false
    dynamic var followers_count: Int64 = -1
    dynamic var friends_count: Int64 = -1
    dynamic var listed_count: Int64 = -1
    dynamic var created_at: String = ""
    dynamic var favourites_count: Int64 = -1
    dynamic var utc_offset: Int64 = -1
    dynamic var time_zone: String = ""
    // dynamic var geo_enabled: Bool =
    dynamic var verified: Bool = false
    dynamic var statuses_count: Int64 = -1
    dynamic var lang: String = ""
    // dynamic var contributors_enabled: Bool =
    // dynamic var is_translator: Bool =
    // dynamic var is_translation_enabled: Bool =
    dynamic var profile_background_color: String = ""
    dynamic var profile_background_image_url: String = ""
    dynamic var profile_background_image_url_https: String = ""
    // dynamic var profile_background_tile: Bool =
    dynamic var profile_image_url: String = ""
    dynamic var profile_image_url_https: String = ""
    dynamic var profile_link_color: String = ""
    // dynamic var profile_sidebar_border_color: String =
    // dynamic var profile_sidebar_fill_color: String =
    dynamic var profile_text_color: String = ""
    dynamic var profile_use_background_image: Bool = false
    dynamic var default_profile: Bool = false
    dynamic var default_profile_image: Bool = false
    dynamic var following: Bool = false
    dynamic var follow_request_sent: Bool = false
    dynamic var notifications: Bool = false
    dynamic var profile_banner_url: String = ""

    // MARK: - Custom

    dynamic var unread_status_count: Int64 = -1

    var account: AccountModel? {
        return (self.linkingObjects(AccountModel.self, forProperty: "profile") as [AccountModel]).first
    }

    func toData() -> User {
        return User(
            id: id,
            id_str: id_str,
            name: name,
            screen_name: screen_name,
            location: location,
            description: t_description,
            url: url == "" ? nil : url,
            protected: protected,
            followers_count: followers_count,
            friends_count: friends_count,
            listed_count: listed_count,
            created_at: created_at,
            favourites_count: favourites_count,
            utc_offset: utc_offset == -1 ? nil : utc_offset,
            time_zone: time_zone == "" ? nil : time_zone,
            verified: verified,
            statuses_count: statuses_count,
            lang: lang,
            profile_background_color: profile_background_color,
            profile_background_image_url: profile_background_image_url,
            profile_background_image_url_https: profile_background_image_url_https,
            profile_image_url: profile_image_url,
            profile_image_url_https: profile_image_url_https,
            profile_link_color: profile_link_color,
            profile_text_color: profile_text_color,
            profile_use_background_image: profile_use_background_image,
            default_profile: default_profile,
            default_profile_image: default_profile_image,
            following: following,
            follow_request_sent: follow_request_sent,
            notifications: notifications,
            profile_banner_url: profile_banner_url == "" ? nil : profile_banner_url,
            unread_status_count: unread_status_count == -1 ? nil : unread_status_count
        )
    }

}
