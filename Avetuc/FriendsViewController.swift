//
//  ViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import UIKit
import RxSwift

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

    private let bag = DisposeBag()
    private var friends = [User]()

    // MARK: - View Delegate

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(
            self,
            action: Selector("refreshControlValueChanged:"),
            forControlEvents: .ValueChanged)

        River.instance.observable_friends
            >- subscribeNext { [unowned self] (friends, diffResult) in
                self.refreshControl!.endRefreshing()
                self.friends = friends
                self.tableView.reloadDataFrom(diffResult)
            }
            >- self.bag.addDisposable
    }

    func refreshControlValueChanged(refreshControl: UIRefreshControl) {
        if refreshControl.refreshing {
            action_updateAccount(nil)
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.friends[indexPath.row]
        let tweetViewController = TweetsViewController(user: user)
        self.navigationController!.pushViewController(tweetViewController, animated: true)
    }

    // MARK: - No use

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
}
