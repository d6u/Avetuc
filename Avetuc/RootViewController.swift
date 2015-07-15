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

        accountListener = AccountsStore.instance.on { storeData in
            println("emitted")
            if let account = storeData.cur {
                println("has account")
            } else {
                self.presentIntroView()
            }
        }
    }

    let friendsTableViewController = FriendsViewController()

    private var accountListener: Listener?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(self.friendsTableViewController, animated: false)
        AccountActions.askCurrentAccount()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
