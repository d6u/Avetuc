//
//  UserData.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct UserData {
    let created_at: String
    let description: String
    let favourites_count: Int64
    let followers_count: Int64
    let following: Bool
    let friends_count: Int64
    let id_str: String
    let lang: String
    let listed_count: Int64
    let location: String
    let name: String
    let profile_image_url: String
    let screen_name: String
    let statuses_count: Int64
    let time_zone: String?
    let unread_count: Int64?
    let url: String?
    let utc_offset: Int64?
    let verified: Bool

    let following_account_user_id: String?
    let profile_account_user_id: String?
}

extension UserData: Decodable {

    static func create(created_at: String)(description: String)(favourites_count: Int64)(followers_count: Int64)(following: Bool)(friends_count: Int64)(id_str: String)(lang: String)(listed_count: Int64)(location: String)(name: String)(profile_image_url: String)(screen_name: String)(statuses_count: Int64)(time_zone: String?)(unread_count: Int64?)(url: String?)(utc_offset: Int64?)(verified: Bool)(following_account_user_id: String?)(profile_account_user_id: String?) -> UserData
    {
        return UserData(created_at: created_at, description: description, favourites_count: favourites_count, followers_count: followers_count, following: following, friends_count: friends_count, id_str: id_str, lang: lang, listed_count: listed_count, location: location, name: name, profile_image_url: profile_image_url, screen_name: screen_name, statuses_count: statuses_count, time_zone: time_zone, unread_count: unread_count, url: url, utc_offset: utc_offset, verified: verified, following_account_user_id: following_account_user_id, profile_account_user_id: profile_account_user_id)
    }

    static func decode(j: JSON) -> Decoded<UserData> {

        // Have to breakup decode into multiple chunk and use type cast,
        // because Swift compiler cannot handle such complex expression ¯\_(ツ)_/¯
        typealias Halved = Decoded<String -> String -> String -> Int64 -> String? -> Int64? -> String? -> Int64? -> Bool -> String? -> String? -> UserData>

        let f: Halved = UserData.create
            <^> j <| "created_at"
            <*> j <| "description"
            <*> j <| "favourites_count"
            <*> j <| "followers_count"
            <*> j <| "following"
            <*> j <| "friends_count"
            <*> j <| "id_str"
            <*> j <| "lang"
            <*> j <| "listed_count"
            <*> j <| "location"

        return f
            <*> j <| "name"
            <*> j <| "profile_image_url"
            <*> j <| "screen_name"
            <*> j <| "statuses_count"
            <*> j <|? "time_zone"
            <*> j <|? "unread_count"
            <*> j <|? "url"
            <*> j <|? "utc_offset"
            <*> j <| "verified"
            <*> j <|? "following_account_user_id"
            <*> j <|? "profile_account_user_id"
    }
}
