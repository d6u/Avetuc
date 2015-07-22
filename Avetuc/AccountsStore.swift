//
//  AccountsStore.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

typealias StoreAccountEventHandler = (StoreEvent<Account>) -> Void

class AccountsStore {

    static let instance = AccountsStore()

    init() {
        self.listener = Dispatcher.instance.register { (account: Account?) -> Void in
            self.account = account
            self.event.emit(StoreEvent<Account>(cur: account, pre: self.account))
        }
    }

    private var account: Account?

    private let event = Event<StoreEvent<Account>>()
    private var listener: Listener?

    func on(callback: StoreAccountEventHandler) -> Listener {
        return event.on(callback)
    }

}
