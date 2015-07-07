//
//  BaseModel.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/6/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class TimestampUtility: BaseUtility {

    static var formatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()

    @NSManaged var created_at: String

    var created_at_date: NSDate {
        get {
            return TimestampUtility.formatter.dateFromString(self.created_at)!
        }
    }

}
