//
//  Account.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreData

class Account: BaseUtility {

    @NSManaged var accountIdentifier: String
    @NSManaged var lastFetchSinceId: String
    @NSManaged var token: String
    @NSManaged var tokenSecret: String
    @NSManaged var userId: String
    @NSManaged var friends: NSSet
    @NSManaged var profile: User
    @NSManaged var relatedTweets: NSSet

}
