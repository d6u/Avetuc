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

}
