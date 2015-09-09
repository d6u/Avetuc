import UIKit
import RxSwift
import SnapKit

class TweetsViewController: UITableViewController {

    let bag = DisposeBag()
    let user: User
    var tweets = [TweetCellData]()
    var isMonitoringScroll = false

    init(user: User) {
        self.user = user

        super.init(nibName: nil, bundle: nil)

        self.navigationItem.title = user.name

        self.tableView.allowsSelection = false
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.registerClass(TweetCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.rx_controlEvents(.ValueChanged)
            >- subscribeNext { [unowned self] in
                if self.refreshControl!.refreshing {
                    self.refreshControl!.endRefreshing()
                    action_requestUpdateAccount(nil)
                }
            }
            >- self.bag.addDisposable
    }

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
