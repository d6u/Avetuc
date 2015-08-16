import UIKit
import RxSwift

extension TweetsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        River.instance.getTweetsObservable(self.user)
            >- subscribeNext { [unowned self] tweets in
                self.tweets = tweets
                self.tableView.reloadData()
            }
            >- self.bag.addDisposable
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

//    func reloadTable(diffResult: DiffResult<TweetCellData>)
//    {
//        switch diffResult {
//        case .Initial(let friends):
//            #if DEBUG
//                println("tweets table initial load")
//            #endif
//
//            self.tableView.reloadData()
//        case .Differences(let differences):
//            #if DEBUG
//                println("tweets table diff load")
//                println(differences)
//            #endif
//
//            self.tableView.beginUpdates()
//
//            let insertIndexPaths = differences.insert.map { NSIndexPath(forRow: $0.index, inSection: 0) }
//            self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Bottom)
//
//            let removeIndexPaths = differences.remove.map { NSIndexPath(forRow: $0.index, inSection: 0) }
//            self.tableView.deleteRowsAtIndexPaths(removeIndexPaths, withRowAnimation: .Bottom)
//
//            for update in differences.update {
//                let indexPath = NSIndexPath(forRow: update.index, inSection: 0)
//                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TweetCell {
//                    cell.loadTweet(update.element, user: self.user)
//                }
//            }
//
//            for item in differences.move {
//                self.tableView.moveRowAtIndexPath(
//                    NSIndexPath(forRow: item.oldIndex, inSection: 0),
//                    toIndexPath: NSIndexPath(forRow: item.newIndex, inSection: 0))
//            }
//
//            self.tableView.endUpdates()
//        }
//    }
