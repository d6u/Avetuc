//
//  UserApiData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct UserApiData {

    let id: Int64
    let id_str: String
    let name: String?
    let screen_name: String
    let location: String
    let description: String
    let url: String?
    let entities: UserEntities
    let protected: Bool
    let followers_count: Int64
    let friends_count: Int64
    let listed_count: Int64
    let created_at: String
    let favourites_count: Int64
    let utc_offset: Int64?
    let time_zone: String?
    let geo_enabled: Bool
    let verified: Bool
    let statuses_count: Int64
    let lang: String
    let contributors_enabled: Bool
    let is_translator: Bool
    let is_translation_enabled: Bool
    let profile_background_color: String
    let profile_background_image_url: String
    let profile_background_image_url_https: String
    let profile_background_tile: Bool
    let profile_image_url: String
    let profile_image_url_https: String
    let profile_link_color: String
    let profile_sidebar_border_color: String
    let profile_sidebar_fill_color: String
    let profile_text_color: String
    let profile_use_background_image: Bool
    let default_profile: Bool
    let default_profile_image: Bool
    let following: Bool
    let follow_request_sent: Bool
    let notifications: Bool
    let profile_banner_url: String?

}

extension UserApiData: Decodable {

    static func create
        (id: Int64)
        (id_str: String)
        (name: String?)
        (screen_name: String)
        (location: String)
        (description: String)
        (url: String?)
        (entities: UserEntities)
        (protected: Bool)
        (followers_count: Int64)
        (friends_count: Int64)
        (listed_count: Int64)
        (created_at: String)
        (favourites_count: Int64)
        (utc_offset: Int64?)
        (time_zone: String?)
        (geo_enabled: Bool)
        (verified: Bool)
        (statuses_count: Int64)
        (lang: String)
        (contributors_enabled: Bool)
        (is_translator: Bool)
        (is_translation_enabled: Bool)
        (profile_background_color: String)
        (profile_background_image_url: String)
        (profile_background_image_url_https: String)
        (profile_background_tile: Bool)
        (profile_image_url: String)
        (profile_image_url_https: String)
        (profile_link_color: String)
        (profile_sidebar_border_color: String)
        (profile_sidebar_fill_color: String)
        (profile_text_color: String)
        (profile_use_background_image: Bool)
        (default_profile: Bool)
        (default_profile_image: Bool)
        (following: Bool)
        (follow_request_sent: Bool)
        (notifications: Bool)
        (profile_banner_url: String?)
        -> UserApiData
    {
        return UserApiData(
            id: id,
            id_str: id_str,
            name: name,
            screen_name: screen_name,
            location: location,
            description: description,
            url: url,
            entities: entities,
            protected: protected,
            followers_count: followers_count,
            friends_count: friends_count,
            listed_count: listed_count,
            created_at: created_at,
            favourites_count: favourites_count,
            utc_offset: utc_offset,
            time_zone: time_zone,
            geo_enabled: geo_enabled,
            verified: verified,
            statuses_count: statuses_count,
            lang: lang,
            contributors_enabled: contributors_enabled,
            is_translator: is_translator,
            is_translation_enabled: is_translation_enabled,
            profile_background_color: profile_background_color,
            profile_background_image_url: profile_background_image_url,
            profile_background_image_url_https: profile_background_image_url_https,
            profile_background_tile: profile_background_tile,
            profile_image_url: profile_image_url,
            profile_image_url_https: profile_image_url_https,
            profile_link_color: profile_link_color,
            profile_sidebar_border_color: profile_sidebar_border_color,
            profile_sidebar_fill_color: profile_sidebar_fill_color,
            profile_text_color: profile_text_color,
            profile_use_background_image: profile_use_background_image,
            default_profile: default_profile,
            default_profile_image: default_profile_image,
            following: following,
            follow_request_sent: follow_request_sent,
            notifications: notifications,
            profile_banner_url: profile_banner_url
        )
    }

    static func decode(j: JSON) -> Decoded<UserApiData> {

        // Have to breakup decode into multiple chunk and use type cast,
        // because Swift compiler cannot handle such complex expression ¯\_(ツ)_/¯
        typealias Halved1 = Decoded<String -> String? -> UserEntities -> Bool -> Int64 -> Int64 -> Int64 -> String -> Int64 -> Int64? -> String? -> Bool -> Bool -> Int64 -> String -> Bool -> Bool -> Bool -> String -> String -> String -> Bool -> String -> String -> String -> String -> String -> String -> Bool -> Bool -> Bool -> Bool -> Bool -> Bool -> String? -> UserApiData>

        typealias Halved2 = Decoded<Int64 -> Int64 -> String -> Int64 -> Int64? -> String? -> Bool -> Bool -> Int64 -> String -> Bool -> Bool -> Bool -> String -> String -> String -> Bool -> String -> String -> String -> String -> String -> String -> Bool -> Bool -> Bool -> Bool -> Bool -> Bool -> String? -> UserApiData>

        typealias Halved3 = Decoded<String? -> Bool -> Bool -> Int64 -> String -> Bool -> Bool -> Bool -> String -> String -> String -> Bool -> String -> String -> String -> String -> String -> String -> Bool -> Bool -> Bool -> Bool -> Bool -> Bool -> String? -> UserApiData>

        typealias Halved4 = Decoded<Bool -> Bool -> Bool -> String -> String -> String -> Bool -> String -> String -> String -> String -> String -> String -> Bool -> Bool -> Bool -> Bool -> Bool -> Bool -> String? -> UserApiData>

        typealias Halved5 = Decoded<String -> Bool -> String -> String -> String -> String -> String -> String -> Bool -> Bool -> Bool -> Bool -> Bool -> Bool -> String? -> UserApiData>

        typealias Halved6 = Decoded<String -> String -> String -> Bool -> Bool -> Bool -> Bool -> Bool -> Bool -> String? -> UserApiData>

        typealias Halved7 = Decoded<Bool -> Bool -> Bool -> Bool -> String? -> UserApiData>

        let f1: Halved1 = UserApiData.create
            <^> j <| "id"
            <*> j <| "id_str"
            <*> j <|? "name"
            <*> j <| "screen_name"
            <*> j <| "location"

        let f2: Halved2 = f1
            <*> j <| "description"
            <*> j <|? "url"
            <*> j <| "entities"
            <*> j <| "protected"
            <*> j <| "followers_count"

        let f3: Halved3 = f2
            <*> j <| "friends_count"
            <*> j <| "listed_count"
            <*> j <| "created_at"
            <*> j <| "favourites_count"
            <*> j <|? "utc_offset"

        let f4: Halved4 = f3
            <*> j <|? "time_zone"
            <*> j <| "geo_enabled"
            <*> j <| "verified"
            <*> j <| "statuses_count"
            <*> j <| "lang"

        let f5: Halved5 = f4
            <*> j <| "contributors_enabled"
            <*> j <| "is_translator"
            <*> j <| "is_translation_enabled"
            <*> j <| "profile_background_color"
            <*> j <| "profile_background_image_url"

        let f6: Halved6 = f5
            <*> j <| "profile_background_image_url_https"
            <*> j <| "profile_background_tile"
            <*> j <| "profile_image_url"
            <*> j <| "profile_image_url_https"
            <*> j <| "profile_link_color"

        let f7: Halved7 = f6
            <*> j <| "profile_sidebar_border_color"
            <*> j <| "profile_sidebar_fill_color"
            <*> j <| "profile_text_color"
            <*> j <| "profile_use_background_image"
            <*> j <| "default_profile"

        return f7
            <*> j <| "default_profile_image"
            <*> j <| "following"
            <*> j <| "follow_request_sent"
            <*> j <| "notifications"
            <*> j <|? "profile_banner_url"
    }
}
