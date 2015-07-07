//
//  UrlEntity.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class UrlEntity: Entity {

    @NSManaged var displayUrl: String
    @NSManaged var expandedUrl: String
    @NSManaged var url: String

}
