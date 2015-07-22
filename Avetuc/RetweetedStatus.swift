//
//  RetweetedStatus.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct RetweetedStatus {

    let created_at: String
    let id: Int64
    let id_str: String
    let text: String
    let source: String
    let truncated: Bool
    let in_reply_to_status_id: Int64?
    let in_reply_to_status_id_str: String?
    let in_reply_to_user_id: Int64?
    let in_reply_to_user_id_str: String?
    let in_reply_to_screen_name: String?
    let user: UserApiData
    let geo: Coordinates?
    let coordinates: Coordinates?
    let place: Place?
    let retweet_count: Int64
    let favorite_count: Int64
    let entities: Entities
    let favorited: Bool
    let retweeted: Bool
    let possibly_sensitive: Bool
    let possibly_sensitive_appealable: Bool
    let lang: String
    let extended_entities: ExtendedEntities

}

extension RetweetedStatus: Decodable {

    static func create
        (created_at: String)
        (id: Int64)
        (id_str: String)
        (text: String)
        (source: String)
        (truncated: Bool)
        (in_reply_to_status_id: Int64?)
        (in_reply_to_status_id_str: String?)
        (in_reply_to_user_id: Int64?)
        (in_reply_to_user_id_str: String?)
        (in_reply_to_screen_name: String?)
        (user: UserApiData)
        (geo: Coordinates?)
        (coordinates: Coordinates?)
        (place: Place?)
        (retweet_count: Int64)
        (favorite_count: Int64)
        (entities: Entities)
        (favorited: Bool)
        (retweeted: Bool)
        (possibly_sensitive: Bool)
        (possibly_sensitive_appealable: Bool)
        (lang: String)
        (extended_entities: ExtendedEntities)
        -> RetweetedStatus
    {
        return RetweetedStatus(
            created_at: created_at,
            id: id,
            id_str: id_str,
            text: text,
            source: source,
            truncated: truncated,
            in_reply_to_status_id: in_reply_to_status_id,
            in_reply_to_status_id_str: in_reply_to_status_id_str,
            in_reply_to_user_id: in_reply_to_user_id,
            in_reply_to_user_id_str: in_reply_to_user_id_str,
            in_reply_to_screen_name: in_reply_to_screen_name,
            user: user,
            geo: geo,
            coordinates: coordinates,
            place: place,
            retweet_count: retweet_count,
            favorite_count: favorite_count,
            entities: entities,
            favorited: favorited,
            retweeted: retweeted,
            possibly_sensitive: possibly_sensitive,
            possibly_sensitive_appealable: possibly_sensitive_appealable,
            lang: lang,
            extended_entities: extended_entities
        )
    }

    static func decode(j: JSON) -> Decoded<RetweetedStatus> {

        println("decoding RetweetedStatus")

        // Have to breakup decode into multiple chunk and use type cast,
        // because Swift compiler cannot handle such complex expression ¯\_(ツ)_/¯
        typealias Partial1 = Decoded<Bool -> Int64? -> String? -> Int64? -> String? -> String? -> UserApiData -> Coordinates? -> Coordinates? -> Place? -> Int64 -> Int64 -> Entities -> Bool -> Bool -> Bool -> Bool -> String -> ExtendedEntities -> RetweetedStatus>

        typealias Partial2 = Decoded<String? -> UserApiData -> Coordinates? -> Coordinates? -> Place? -> Int64 -> Int64 -> Entities -> Bool -> Bool -> Bool -> Bool -> String -> ExtendedEntities -> RetweetedStatus>

        typealias Partial3 = Decoded<Int64 -> Int64 -> Entities -> Bool -> Bool -> Bool -> Bool -> String -> ExtendedEntities -> RetweetedStatus>

        typealias Partial4 = Decoded<Bool -> Bool -> String -> ExtendedEntities -> RetweetedStatus>

        let f1: Partial1 = RetweetedStatus.create
            <^> j <| "created_at"
            <*> j <| "id"
            <*> j <| "id_str"
            <*> j <| "text"
            <*> j <| "source"

        let f2: Partial2 = f1
            <*> j <| "truncated"
            <*> j <|? "in_reply_to_status_id"
            <*> j <|? "in_reply_to_status_id_str"
            <*> j <|? "in_reply_to_user_id"
            <*> j <|? "in_reply_to_user_id_str"

        let f3: Partial3 = f2
            <*> j <|? "in_reply_to_screen_name"
            <*> j <| "user"
            <*> j <|? "geo"
            <*> j <|? "coordinates"
            <*> j <|? "place"

        let f4: Partial4 = f3
            <*> j <| "retweet_count"
            <*> j <| "favorite_count"
            <*> j <| "entities"
            <*> j <| "favorited"
            <*> j <| "retweeted"

        return f4
            <*> j <| "possibly_sensitive"
            <*> j <| "possibly_sensitive_appealable"
            <*> j <| "lang"
            <*> j <| "extended_entities"
    }
}
