//
//  TweetsViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import TapLabel

class TweetsViewController: UITableViewController {

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
    var isMonitoringScroll = false

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TweetsViewController {

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

    override func viewDidAppear(animated: Bool) {
        self.isMonitoringScroll = true
        self.scrollViewDidScroll(self.tableView)
    }

    override func viewWillDisappear(animated: Bool) {
        self.isMonitoringScroll = false
        for cell in self.tableView.visibleCells() as! [TweetCell] {
            cell.cancelMakeReadTimer()
        }
    }
}

extension TweetsViewController: UITableViewDataSource {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! TweetCell
        cell.textView.delegate = self
        cell.loadTweet(self.tweets[indexPath.row], user: self.user)
        return cell
    }
}

extension TweetsViewController: UITableViewDelegate {

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = self.tweets[indexPath.row]
        return TweetCell.heightForContent(tweet)
    }
}

extension TweetsViewController: UIScrollViewDelegate {

    override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        // This method will be triggered twice before `viewDidAppear`,
        // which causes funny memory retain issues when calling `visibleCells`
        // Set this flag to prevent it being called before `viewDidAppear`
        if !self.isMonitoringScroll {
            return
        }

        let offset = scrollView.contentOffset.y + 64 // Top offset
        let containerHeight = scrollView.frame.height - 64

        for cell in self.tableView.visibleCells() as! [TweetCell]
        {
            if !cell.parsedTweet!.tweet.is_read
            {
                let bottom = cell.frame.origin.y + cell.frame.height

                if bottom < offset {
                    updateTweetReadState(cell.parsedTweet!.tweet.id, true)
                }
                else if bottom - offset <= containerHeight {
                    cell.setMakeReadTimer()
                }
                else if bottom - offset > containerHeight {
                    cell.cancelMakeReadTimer()
                }
            }
        }
    }
}

extension TweetsViewController: TapLabelDelegate {

    func tapLabel(tapLabel: TapLabel, didSelectLink link: String) {
        let webViewController = WebViewController(url: link)
        self.presentViewController(webViewController, animated: true, completion: nil)
    }
}
