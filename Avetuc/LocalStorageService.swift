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

typealias CreateAccountTask = Task<Float, AccountData, NSError>
typealias CreateUsersTask = Task<Float, [UserData], NSError>

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

    // MARK: Create

    func createAccount(accountData: AccountData) -> CreateAccountTask {
        return CreateAccountTask { progress, fulfill, reject, configure in
            self.dataStack.beginAsynchronous { transaction in
                let account = transaction.create(Into(Account)).fromData(accountData)

                transaction.commit { result -> Void in
                    switch result {
                    case .Success(let hasChanges):
                        println("success! hasChanges? \(hasChanges)")
                        fulfill(accountData)
                    case .Failure(let error):
                        println(error)
                        reject(error)
                    }
                }
            }
        }
    }

    func createUsers(usersData: [UserData]) -> CreateUsersTask {
        return CreateUsersTask { progress, fulfill, reject, configure in
            self.dataStack.beginAsynchronous { transaction in
                let users = usersData.map { transaction.create(Into(User)).fromData($0) }

                transaction.commit { result -> Void in
                    switch result {
                    case .Success(let hasChanges):
                        println("success! hasChanges? \(hasChanges)")
                        fulfill(usersData)
                    case .Failure(let error):
                        println(error)
                        reject(error)
                    }
                }
            }
        }
    }

    // MARK: Read

    func loadDefaultAccount() {
        dataStack.beginAsynchronous {(transaction) in
            let accounts = transaction.fetchAll(From(Account))!
            if let account = accounts.first {
                let accountData = account.toData()
                TwitterApiService.instance.loadTokens(accountData.oauth_token, oauthTokenSecret: accountData.oauth_token_secret)
                AccountActions.emitAccount(accountData)
            } else {
                AccountActions.emitAccount(nil)
            }
        }
    }

    func loadFriendsFor(user_id: String) {
        self.dataStack.beginAsynchronous { transaction in
            let users = transaction.fetchAll(From(User), Where("account_user_id = \(user_id)"))! as [User]
            FriendActions.emitFriends(users.map { $0.toData() })
        }
    }

}
