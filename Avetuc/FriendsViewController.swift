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

        self.tableView.registerClass(FriendTableCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }

    private var accountListener: Listener?
    private var friendsListener: Listener?
    private var friends = [UserData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.accountListener = AccountsStore.instance.on { event in

            // TODO: Handle account switching

            if let account = event.cur {
                FriendActions.loadAllFriends(account.user_id)
            } else {
                self.friends = []
                self.tableView.reloadData()
            }
        }

        self.friendsListener = FriendsStore.instance.on { (data: StoreEvent<[UserData]>) in
            if let friends = data.cur {
                println("Friends count", friends.count)
                self.friends = friends
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - TableView Delegate

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! FriendTableCell
        cell.load(self.friends[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FriendTableCell.heightForContent()
    }

    // MARK: - No use

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

}
