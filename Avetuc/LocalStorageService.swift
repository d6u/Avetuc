//
//  LocalStoreService.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreStore

class LocalStorageService {

    class var instance: LocalStorageService {
        struct Static {
            static var instance: LocalStorageService?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = LocalStorageService()
        }
        return Static.instance!
    }

    let dataStack: DataStack

    init() {
        dataStack = DataStack(modelName: "Avetuc")

        switch dataStack.addSQLiteStoreAndWait(
            "Avetuc.sqlite",
            configuration: "Default",
            automigrating: true,
            resetStoreOnMigrationFailure: true)
        {
        case .Success(let persistentStore):
            println("Successfully created an sqlite store: \(persistentStore)")
        case .Failure(let error):
            println("Failed creating an sqlite store with error :\(error.description)")
        }
    }

    func loadDefaultAccount() {
        dataStack.beginAsynchronous {(transaction) in
            let accounts = transaction.fetchAll(From(Account))!
            if let account = accounts.first {
                AccountActions.emitAccount(nil)
            } else {
                AccountActions.emitAccount(nil)
            }
        }
    }

}
