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

    func fromApiData(data: UserMention) -> UserMentionEntityModel {
        self.screen_name = data.screen_name
        self.name = data.name
        self.id = data.id
        self.id_str = data.id_str
        self.head_indices = data.indices[0]
        self.tail_indices = data.indices[1]
        return self
    }

    func toData() -> UserMention {
        return UserMention(screen_name: screen_name, name: name, id: id, id_str: id_str, indices: [head_indices, tail_indices])
    }

}
