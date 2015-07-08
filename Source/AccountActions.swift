//
//  ModelActions.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

struct AccountActions {

    static func emitAccount(account: AccountData?) {
        Dispatcher.instance.dispatchAccountData(account)
    }

    static func askCurrentAccount() {
        LocalStorageService.instance.loadDefaultAccount()
    }

}
