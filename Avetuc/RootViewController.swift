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

    init() {
        super.init(nibName: nil, bundle: nil)

        accountListener = AccountsStore.instance.on { account in
            if let account = account {
                println("has account")
            } else {
                self.presentIntroView()
            }
        }
    }

    private let event = Event<String>()
    private var accountListener: Listener?

    let friendsTableViewController = FriendsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(friendsTableViewController, animated: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        AccountActions.askCurrentAccount()
    }

    func presentIntroView()
    {
        let introViewController = IntroViewController()
//        introViewController.transitioningDelegate = self.transitionDelegate
//        introViewController.modalPresentationStyle = .Custom
        self.presentViewController(introViewController, animated: true, completion: nil)
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
