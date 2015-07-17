//
//  AccountsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

typealias StoreAccountEventHandler = (StoreEvent<AccountData>) -> Void

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
        self.listener = Dispatcher.instance.register { (account: AccountData?) -> Void in
            self.account = account
            self.event.emit(StoreEvent<AccountData>(cur: account, pre: self.account))
        }
    }

    private var account: AccountData?

    private let event = Event<StoreEvent<AccountData>>()
    private var listener: Listener?

    func on(callback: StoreAccountEventHandler) -> Listener {
        return event.on(callback)
    }

}
