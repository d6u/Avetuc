//
//  UserMentionEntityModel.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RealmSwift

class UserMentionEntityModel: Object {

    dynamic var screen_name: String = ""
    dynamic var name: String = ""
    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""
    dynamic var head_indices: Int64 = -1
    dynamic var tail_indices: Int64 = -1

}
