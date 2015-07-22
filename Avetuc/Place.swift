//
//  Place.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct Place {
    let id: String
    let url: String
    let place_type: String
    let name: String
    let full_name: String
    let country_code: String
    let country: String
    // let bounding_box:
}

extension Place: Decodable {

    static func create
        (id: String)
        (url: String)
        (place_type: String)
        (name: String)
        (full_name: String)
        (country_code: String)
        (country: String) -> Place
    {
        return Place(
            id: id,
            url: url,
            place_type: place_type,
            name: name,
            full_name: full_name,
            country_code: country_code,
            country: country
        )
    }

    static func decode(j: JSON) -> Decoded<Place> {
        println("decoding Place")
        return Place.create
            <^> j <| "id"
            <*> j <| "url"
            <*> j <| "place_type"
            <*> j <| "name"
            <*> j <| "full_name"
            <*> j <| "country_code"
            <*> j <| "country"
    }
}
