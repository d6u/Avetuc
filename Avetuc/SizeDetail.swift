//
//  SizeDetail.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/21/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Argo
import Runes

struct SizeDetail {
    let w: Int64
    let h: Int64
    let resize: String
}

extension SizeDetail: Decodable {

    static func create
        (w: Int64)
        (h: Int64)
        (resize: String) -> SizeDetail
    {
        return SizeDetail(w: w, h: h, resize: resize)
    }

    static func decode(j: JSON) -> Decoded<SizeDetail> {
        return SizeDetail.create
            <^> j <|  "w"
            <*> j <| "h"
            <*> j <| "resize"
    }
}
