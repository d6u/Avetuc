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
        Dispatcher.instance.dispatch(account)
    }

    static func askCurrentAccount() {
        LocalStorageService.instance.loadDefaultAccount()
    }

    static func addAccountThroughWeb() {
        TwitterApiService.instance.addAccountThroughWeb()
    }

    static func handleCallbackUrl(url: NSURL) {
        TwitterApiService.instance.handleOauthCallback(url)
    }

}
