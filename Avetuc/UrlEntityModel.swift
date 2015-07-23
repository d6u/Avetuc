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

    func fromApiData(data: Url) -> UrlEntityModel {
        self.url = data.url
        self.expanded_url = data.expanded_url
        self.display_url = data.display_url
        self.head_indices = data.indices[0]
        self.tail_indices = data.indices[1]
        return self
    }

    func toData() -> Url {
        return Url(url: url, expanded_url: expanded_url, display_url: display_url, indices: [head_indices, tail_indices])
    }

}
