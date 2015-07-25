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
    var accountConsumer: EventConsumer?

    func loadAccount(account: Account) {
        self.account = account

        if let intro = self.introViewController {
            intro.dismissViewControllerAnimated(true, completion: nil)
            self.introViewController = nil
        }

        fetchFriendsOfAccount(account.user_id)
        fetchHomeTimelineOfAccount(account.user_id, since_id: account.last_fetch_since_id)
        loadAllFriendsOfAccount(account.user_id)
    }

    func presentIntroView() {
        self.introViewController = IntroViewController()
        self.presentViewController(self.introViewController!, animated: true, completion: nil)
    }

    // MARK: - Delegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(self.friendsTableViewController, animated: false)

        self.accountConsumer = listen(.Account) { (result: AccountResult) in
            switch result {
            case .Success(let account):
                loadTokens(oauthToken: account.oauth_token, oauthTokenSecret: account.oauth_token_secret)
                self.loadAccount(account)
            case .NoAccount:
                if self.introViewController == nil {
                    self.presentIntroView()
                }
            default:
                break
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadDefaultAccount()
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
