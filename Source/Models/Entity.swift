//
//  Entity.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class Entity: NSManagedObject {

    @NSManaged var displayStr: String
    @NSManaged var indexBegin: Int64
    @NSManaged var indexEnd: Int64
    @NSManaged var parsedIndicesBegin: Int64
    @NSManaged var parsedIndicesEnd: Int64
    @NSManaged var targetStr: String
    @NSManaged var type: Int64
    @NSManaged var tweet: Tweet

}
