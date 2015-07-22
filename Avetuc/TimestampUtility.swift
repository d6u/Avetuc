//
//  BaseModel.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/6/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData


let Dformatter: NSDateFormatter = {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    return formatter
}()
