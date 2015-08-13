import Foundation
import UIKit
import TapLabel
import RxSwift

class TweetsViewController: UITableViewController {

    init(user: User) {
        self.user = user

        super.init(nibName: nil, bundle: nil)

        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.registerClass(TweetCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
    }

    let bag = DisposeBag()
    let user: User
    var tweets = [TweetCellData]()
    var isMonitoringScroll = false

    func refreshControlValueChanged(refreshControl: UIRefreshControl) {
        if refreshControl.refreshing {
            action_updateAccount(nil)
        }
    }

    func reloadTable(diffResult: DiffResult<TweetCellData>)
    {
        switch diffResult {
        case .Initial(let friends):
            #if DEBUG
                println("tweets table initial load")
            #endif

            self.tableView.reloadData()
        case .Differences(let differences):
            #if DEBUG
                println("tweets table diff load")
                println(differences)
            #endif

            self.tableView.beginUpdates()

            let insertIndexPaths = differences.insert.map { NSIndexPath(forRow: $0.index, inSection: 0) }
            self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Bottom)

            let removeIndexPaths = differences.remove.map { NSIndexPath(forRow: $0.index, inSection: 0) }
            self.tableView.deleteRowsAtIndexPaths(removeIndexPaths, withRowAnimation: .Bottom)

            for update in differences.update {
                let indexPath = NSIndexPath(forRow: update.index, inSection: 0)
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TweetCell {
                    cell.loadTweet(update.element, user: self.user)
                }
            }

            for item in differences.move {
                self.tableView.moveRowAtIndexPath(
                    NSIndexPath(forRow: item.oldIndex, inSection: 0),
                    toIndexPath: NSIndexPath(forRow: item.newIndex, inSection: 0))
            }
            
            self.tableView.endUpdates()
        }
    }

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TweetsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(
            self,
            action: Selector("refreshControlValueChanged:"),
            forControlEvents: .ValueChanged)

        River.instance.observable_statuses
            >- subscribeNext { [weak self] (tweets: [TweetCellData], diffResult: DiffResult<TweetCellData>) in
                self?.refreshControl!.endRefreshing()
                self?.tweets = tweets
                self?.reloadTable(diffResult)
            }
            >- self.bag.addDisposable

        action_selectFriend(self.user.id)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.isMonitoringScroll = true
        self.scrollViewDidScroll(self.tableView)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        return TweetCell.heightForContent(self.tweets[indexPath.row])
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
            if let cellData = cell.cellData where !cellData.tweet.is_read
            {
                let bottom = cell.frame.origin.y + cell.frame.height

                if bottom < offset {
                    action_updateTweetReadState(cellData.tweet.id, true)
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
