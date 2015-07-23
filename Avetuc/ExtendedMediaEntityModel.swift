//
//  ExtendedMediaEntityModel.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RealmSwift

class ExtendedMediaEntityModel: Object {

    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""
    dynamic var media_url: String = ""
    dynamic var media_url_https: String = ""
    dynamic var url: String = ""
    dynamic var display_url: String = ""
    dynamic var expanded_url: String = ""
    dynamic var type: String = ""

    dynamic var head_indices: Int64 = -1
    dynamic var tail_indices: Int64 = -1

    dynamic var small_sizes: SizeModel?
    dynamic var large_sizes: SizeModel?
    dynamic var thumb_sizes: SizeModel?
    dynamic var medium_sizes: SizeModel?

}
