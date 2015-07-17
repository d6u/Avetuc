//
//  BaseUtility.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/6/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class BaseUtility: NSManagedObject {

    var isDirty: Bool {
        return self.changedValues().count != 0
    }

    func isPropertyDefined(name: String) -> Bool {
        return self.entity.attributesByName[name] != nil
    }

    func toDict() -> [String: AnyObject] {
        let keys = self.entity.attributesByName.keys.array
        return self.dictionaryWithValuesForKeys(keys) as! [String: AnyObject]
    }

}
