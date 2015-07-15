//
//  MentionEntity.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class MentionEntity: Entity {

    @NSManaged var idStr: String
    @NSManaged var name: String
    @NSManaged var screenName: String

}
