//
//  Dispatcher.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import EmitterKit

class Dispatcher {

    class var instance: Dispatcher {
        struct Static {
            static var instance: Dispatcher?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = Dispatcher()
        }
        return Static.instance!
    }

    let accountEvent = Event<AccountData?>()

    func register(type: DispatcherEventType, callback: AccountDataHandler) -> Listener {
        switch type {
        case .Account:
            return accountEvent.on(callback)
        default:
            assert(false, "Type other than Account is not implemented yet")
            return accountEvent.on(callback)
        }
    }

    func dispatchAccountData(account: AccountData?) {
        self.accountEvent.emit(account)
    }

}
