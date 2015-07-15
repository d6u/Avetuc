//
//  MediaSize.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class MediaSize: NSManagedObject {

    @NSManaged var height: Int64
    @NSManaged var resize: String
    @NSManaged var type: String
    @NSManaged var width: Int64
    @NSManaged var photo: PhotoEntity

}
