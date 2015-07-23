//
//  SizeModel.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RealmSwift

class SizeModel: Object {

    dynamic var type: String = ""
    dynamic var w: Int64 = -1
    dynamic var h: Int64 = -1
    dynamic var resize: String = ""

    func fromApiData(type: SizeType, data: SizeDetail) -> SizeModel {
        self.type = type.rawValue
        self.w = data.w
        self.h = data.h
        self.resize = data.resize
        return self
    }

    func toData() -> Size {
        return Size(type: SizeType(rawValue: self.type)!, w: w, h: h, resize: resize)
    }

}
