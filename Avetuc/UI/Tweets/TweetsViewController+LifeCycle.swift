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
