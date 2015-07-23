//
//  UrlEntityModel.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RealmSwift

class UrlEntityModel: Object {

    dynamic var url: String = ""
    dynamic var expanded_url: String = ""
    dynamic var display_url: String = ""
    dynamic var head_indices: Int64 = -1
    dynamic var tail_indices: Int64 = -1

}
