//
//  Geo.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct Coordinates {
    let type: String
    let coordinates: [Float]
}

extension Coordinates: Decodable {

    static func create
        (type: String)
        (coordinates: [Float]) -> Coordinates
    {
        return Coordinates(
            type: type,
            coordinates: coordinates
        )
    }

    static func decode(j: JSON) -> Decoded<Coordinates> {
        return Coordinates.create
            <^> j <| "type"
            <*> j <|| "coordinates"
    }
}
