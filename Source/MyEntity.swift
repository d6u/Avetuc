//
//  MyEntity.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class MyEntity: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var count: Int64

}
