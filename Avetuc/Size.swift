//
//  Size.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/21/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct Size {
    let small: SizeDetail
    let large: SizeDetail
    let thumb: SizeDetail
    let medium: SizeDetail
}

extension Size: Decodable {

    static func create
        (small: SizeDetail)
        (large: SizeDetail)
        (thumb: SizeDetail)
        (medium: SizeDetail) -> Size
    {
        return Size(small: small, large: large, thumb: thumb, medium: medium)
    }

    static func decode(j: JSON) -> Decoded<Size> {
        return Size.create
            <^> j <|  "small"
            <*> j <| "large"
            <*> j <| "thumb"
            <*> j <| "medium"
    }
}
