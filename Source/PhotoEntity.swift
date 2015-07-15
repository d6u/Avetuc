//
//  PhotoEntity.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class PhotoEntity: Entity {

    @NSManaged var displayUrl: String
    @NSManaged var idStr: String
    @NSManaged var mediaUrl: String
    @NSManaged var sizes: NSSet

}
