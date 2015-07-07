//
//  Dispatcher.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

enum DispatcherEventType {
    case Account
    case Friends
    case Tweets
}

typealias AccountEventCallback = (AccountData) -> Void

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

    var accountEventCallbacks = [AccountEventCallback]()

    func register(type: DispatcherEventType, callback: AccountEventCallback) {
        accountEventCallbacks.append(callback)
    }

    func dispatch(type: DispatcherEventType, payload: [Any]) {
        switch type {
        case .Account:
            let account = payload[0] as! AccountData
            for callback in accountEventCallbacks {
                callback(account)
            }
        case .Friends:
            break
        case .Tweets:
            break
        default:
            break
        }
    }

}
