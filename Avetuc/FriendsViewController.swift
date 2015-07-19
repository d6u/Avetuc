//
//  ViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import UIKit
import EmitterKit

class FriendsViewController:
    UITableViewController,
    UITableViewDelegate,
    UITableViewDataSource
{

    init() {
        super.init(nibName: nil, bundle: nil)

        self.accountListener = AccountsStore.instance.on { event in
            if let account = event.cur {
                FriendActions.loadAllFriends(account.user_id)
                FriendActions.fetchFriends(account.user_id)
            } else {
                self.friends = []
                self.tableView.reloadData()
            }
        }

        self.friendsListener = FriendsStore.instance.on { (data: StoreEvent<[UserData]>) in
            if let friends = data.cur {
                println("get friends", friends.count)
            }
        }
    }

    private var accountListener: Listener?
    private var friendsListener: Listener?
    private var friends = [UserData]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - No use

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

}
