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

class Account: BaseUtility {

    @NSManaged var account_identifier: String?
    @NSManaged var last_fetch_since_id: String?
    @NSManaged var oauth_token: String?
    @NSManaged var oauth_token_secret: String?
    @NSManaged var user_id: String
    @NSManaged var screen_name: String

    func toData() -> AccountData {
        let data: AccountData? = decode(self.toDict())
        return data!
    }

    func fromData(data: AccountData) -> Account {
        self.oauth_token = data.oauth_token
        self.oauth_token_secret = data.oauth_token_secret
        self.user_id = data.user_id
        self.screen_name = data.screen_name
        return self
    }

}
