//
//  LocalStoreService.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import CoreStore
import SwiftTask

typealias LocalStorageTask = Task<Float, AccountData, NSError>

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
                let accountData = account.toData()
                TwitterApiService.instance.loadTokens(accountData)
                AccountActions.emitAccount(accountData)
            } else {
                AccountActions.emitAccount(nil)
            }
        }
    }

    func createAccount(accountData: AccountData) -> LocalStorageTask {
        return LocalStorageTask { progress, fulfill, reject, configure in
            self.dataStack.beginAsynchronous { transaction in
                let account = transaction.create(Into(Account))
                account.oauth_token = accountData.oauth_token
                account.oauth_token_secret = accountData.oauth_token_secret
                account.user_id = accountData.user_id!
                account.screen_name = accountData.screen_name!

                transaction.commit { result -> Void in
                    switch result {
                    case .Success(let hasChanges):
                        println("success! hasChanges? \(hasChanges)")
                        fulfill(account.toData())
                    case .Failure(let error):
                        println(error)
                        reject(error)
                    }
                }
            }
        }
    }

    func loadFriendsFor(user_id: String) {
        self.dataStack.beginAsynchronous { transaction in
            let users = transaction.fetchAll(
                From(User),
                Where("account_user_id = \(user_id)")
            )! as [User]

            let usersData = users.map { user in
                return user.toData()
            }

            FriendActions.emitFriends(usersData)
        }
    }

}
