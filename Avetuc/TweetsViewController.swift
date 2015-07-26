//
//  TweetsViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

class TweetsViewController:
    UITableViewController,
    UITableViewDelegate,
    UITableViewDataSource
{
    init(user: User) {
        self.user = user

        super.init(nibName: nil, bundle: nil)

        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.registerClass(TweetCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
    }

    let user: User
    var tweetsConsumer: EventConsumer?
    var tweetsChangeConsumer: EventConsumer?
    var tweets = [ParsedTweet]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tweetsConsumer = listen(.Tweets(userId: user.id)) { [unowned self] (tweets: [ParsedTweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }

        self.tweetsChangeConsumer = listen(.TweetsUpdate) {
            [unowned self] (data: (userId: Int64, indexPath: NSIndexPath, tweet: ParsedTweet)) in

            self.tweets[data.indexPath.row] = data.tweet

            // No need to call self.tableView.reloadRowsAtIndexPaths
            // Updates handled in table cell
        }

        loadStatusesOfUser(self.user.id)
    }

    // MARK: - Delegate

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! TweetCell
        cell.loadTweet(self.tweets[indexPath.row], user: self.user)
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = self.tweets[indexPath.row]
        return TweetCell.heightForContent(tweet)
    }

    // MARK: - Scroll Delegate

    override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let offset = scrollView.contentOffset.y + 64 // Top offset

        for cell in self.tableView.visibleCells() as! [TweetCell]
        {
            if !cell.parsedTweet!.tweet.is_read && cell.frame.origin.y + cell.frame.height < offset
            {
                updateTweetReadState(cell.parsedTweet!.tweet.id, true)
            }
        }
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
