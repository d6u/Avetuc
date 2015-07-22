//
//  TweetsViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit

//class TweetsViewController:
//    UITableViewController,
//    UITableViewDelegate,
//    UITableViewDataSource
//{
//    init(user: UserData) {
//        self.user = user
//
//        super.init(nibName: nil, bundle: nil)
//
//        self.tableView.layoutMargins = UIEdgeInsetsZero
//        self.tableView.registerClass(TweetCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
//    }
//
//    let user: UserData
//    var tweets = [TweetData]()
//    var tweetsListener: Listener?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.tweetsListener = TweetsStore.instance.on { [unowned self] event in
//            if let tweets = event.cur {
//                println("Tweets count", tweets.count)
//                self.tweets = tweets
//                self.tableView.reloadData()
//            }
//        }
//
//        TweetsActions.loadStatuses(self.user.id_str)
//    }
//
//    // MARK: - Delegate
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.tweets.count
//    }
//
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! TweetCell
//        cell.loadTweet(self.tweets[indexPath.row], userData: self.user)
//        return cell
//    }
//
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 100
//    }
//
//    // MARK: - No use
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
