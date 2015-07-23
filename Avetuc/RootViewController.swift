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
    }

    let friendsTableViewController = FriendsViewController()
    var introViewController: IntroViewController?
    var account: Account?
    var accountListener: Listener?

    func loadAccount(account: Account?)
    {
        self.account = account

        if let account = account {
            if let intro = self.introViewController {
                intro.dismissViewControllerAnimated(true, completion: nil)
                self.introViewController = nil
            }
            loadAllFriendsOfAccount(account.user_id)
        } else {
            if self.introViewController == nil {
                self.presentIntroView()
            }
        }
    }

    // MARK: - Delegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(self.friendsTableViewController, animated: false)

        self.accountListener = AccountsStore.instance.on { [unowned self] event in

            self.loadAccount(event.cur)

            if let account = event.cur {
                fetchFriendsOfAccount(account.user_id)
//                fetchHomeTimelineOfAccount(account.user_id, since_id: account.last_fetch_since_id)
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadDefaultAccount()
    }

    func presentIntroView()
    {
        self.introViewController = IntroViewController()
        self.presentViewController(self.introViewController!, animated: true, completion: nil)
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
