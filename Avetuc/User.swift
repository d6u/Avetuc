//
//  User.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/21/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct User {

    let id: Int64
    let id_str: String
    let name: String
    let screen_name: String
    let location: String
    let description: String
    let url: String?
    // let entities: UserEntities
    let protected: Bool
    let followers_count: Int64
    let friends_count: Int64
    let listed_count: Int64
    let created_at: String
    let favourites_count: Int64
    let utc_offset: Int64?
    let time_zone: String?
    // let geo_enabled: Bool
    let verified: Bool
    let statuses_count: Int64
    let lang: String
    let profile_background_color: String
    let profile_background_image_url: String
    let profile_background_image_url_https: String
    // let profile_background_tile: Bool
    let profile_image_url: String
    let profile_image_url_https: String
    let profile_link_color: String
    // let profile_sidebar_border_color: String
    // let profile_sidebar_fill_color: String
    let profile_text_color: String
    let profile_use_background_image: Bool
    let default_profile: Bool
    let default_profile_image: Bool
    let following: Bool
    let follow_request_sent: Bool
    let notifications: Bool
    let profile_banner_url: String?

    // Custom
    //

    let unread_status_count: Int64?

}
