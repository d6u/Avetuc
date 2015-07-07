//
//  AccountsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

class AccountsStore {

    class var instance: AccountsStore {
        struct Static {
            static var instance: AccountsStore?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = AccountsStore()
        }
        return Static.instance!
    }

    var account: AccountData!

    init() {
        Dispatcher.instance.register(.Account, callback: { (account) -> Void in
            self.account = account
        })
    }

}
