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

//    func setPropertiesFromJson(json: JSON)
//    {
//        if let dict = json.object as? [String: JSON]
//        {
//            for (key, json) in dict
//            {
//                if self.isPropertyDefined(key)
//                {
//                    switch json.type {
//                    case .Bool:
//                        self.setValue(json.boolValue, forKey: key)
//                    case .Number:
//                        self.setValue(json.numberValue, forKey: key)
//                    case .String:
//                        self.setValue(json.stringValue, forKey: key)
//                    case .Null:
//                        self.setValue(nil, forKey: key)
//                    default:
//                        break
//                    }
//                }
//            }
//        }
//    }

}
