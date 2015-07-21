//
//  Account.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData
import Argo
import RealmSwift

class Account: Object {

    override static func indexedProperties() -> [String] {
        return ["user_id"]
    }

    override static func primaryKey() -> String? {
        return "user_id"
    }

    dynamic var account_identifier: String = ""
    dynamic var last_fetch_since_id: String = ""
    dynamic var oauth_token: String = ""
    dynamic var oauth_token_secret: String = ""
    dynamic var user_id: String = ""
    dynamic var screen_name: String = ""

    func toData() -> AccountData {
        var d = [String: AnyObject]()
        for p in self.objectSchema.properties {
            d[p.name] = self[p.name]
        }
        let data: AccountData? = decode(d)
        return data!
    }

}
