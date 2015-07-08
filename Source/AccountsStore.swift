//
//  AccountsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

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

    init() {
        listener = Dispatcher.instance.register(.Account) { account in
            self.account = account
            self.event.emit(account)
        }
    }

    private let event = Event<AccountData?>()
    private var listener: Listener?

    var account: AccountData?

    func on(callback: AccountDataHandler) -> Listener {
        return event.on(callback)
    }

}
