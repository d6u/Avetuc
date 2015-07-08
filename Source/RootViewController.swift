//
//  RootViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit

class RootViewController: UINavigationController {

    private let event = Event<String>()
    private var accountListener: Listener

    let friendsTableViewController = FriendsViewController()

    init() {
        accountListener = AccountsStore.instance.on { account in
            if let account = account {
                println("has account")
            } else {
                println("no account")
            }
        }

        super.init(nibName: nil, bundle: nil)

        AccountActions.askCurrentAccount()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
