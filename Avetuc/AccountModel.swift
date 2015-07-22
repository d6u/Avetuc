//
//  Account.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/16/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift

class AccountModel: Object {

    override static func indexedProperties() -> [String] {
        return ["user_id"]
    }

    override static func primaryKey() -> String? {
        return "user_id"
    }

    dynamic var user_id: String = ""
    dynamic var screen_name: String = ""
    dynamic var oauth_token: String = ""
    dynamic var oauth_token_secret: String = ""
    dynamic var last_fetch_since_id: Int64 = -1

    dynamic var profile: UserModel?

    let friends = List<UserModel>()

    func toData() -> Account {
        return Account(
            user_id: self.user_id,
            screen_name: self.screen_name,
            oauth_token: self.oauth_token,
            oauth_token_secret: self.oauth_token_secret,
            last_fetch_since_id: self.last_fetch_since_id == -1 ? nil : self.last_fetch_since_id
        )
    }

}
