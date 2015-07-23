//
//  Size.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

enum SizeType: String {
    case Small = "small"
    case Large = "large"
    case Thumb = "thumb"
    case Medium = "medium"
}

struct Size {

    let type: SizeType
    let w: Int64
    let h: Int64
    let resize: String
    
}
