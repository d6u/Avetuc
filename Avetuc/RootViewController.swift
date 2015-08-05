//
//  RootViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RootViewController: UINavigationController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    let bag = DisposeBag()
    var disposable_account: Disposable?

    let friendsTableViewController = FriendsViewController()
    var introViewController: IntroViewController?
    var account: Account?

//    func loadAccount(account: Account) {


//        self.friendsTableViewController.loadAccountUserId(account.user_id)
//
//        fetchFriendsOfAccount(account.user_id)
//        fetchHomeTimelineOfAccount(account.user_id, since_id: account.last_fetch_since_id)
//        loadAllFriendsOfAccount(account.user_id)
//    }

    func presentIntroView() {
        self.introViewController = IntroViewController()
        self.presentViewController(self.introViewController!, animated: true, completion: nil)
    }

    // MARK: - Delegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(self.friendsTableViewController, animated: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if self.disposable_account == nil {
            self.disposable_account = River.instance.stream_account
                >- subscribeNext { [unowned self] account in
                    println("stream_account user_id \(account?.user_id)")
                    if let account = account {
                        self.account = account

                        if let intro = self.introViewController {
                            intro.dismissViewControllerAnimated(true, completion: nil)
                            self.introViewController = nil
                        }

                    }
                    else {
                        self.presentIntroView()
                    }
                }

            self.bag.addDisposable(self.disposable_account!)
        }
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
