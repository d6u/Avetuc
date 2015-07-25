//
//  Action.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask

private func dispatch<T>(type: EventType, #data: T) {
    Dispatcher.instance.dispatch(type, data: data)
}

enum AccountResult {
    case NoAccount
    case Success(Account)
    case UserReject
}

func loadDefaultAccount() {
    LocalStorageService.instance.loadDefaultAccount()
        .success { account -> Void in
            if let account = account {
                dispatch(.Account, data: AccountResult.Success(account))
            } else {
                dispatch(.Account, data: AccountResult.NoAccount)
            }
        }
}

let loadTokens = TwitterApiService.instance.loadTokens

func addAccountThroughWeb() {
    TwitterApiService.instance.addAccountThroughWeb()
        .success { result -> Void in
            dispatch(.Account, data: result)
        }
}
