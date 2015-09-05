import UIKit
import RxSwift

class FriendsViewController: UITableViewController {

    private var friendsDisposable: Disposable?
    private(set) var friends = [User]()

    init() {
        super.init(nibName: nil, bundle: nil)

        self.clearsSelectionOnViewWillAppear = false

        self.tableView.registerClass(FriendTableCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.rowHeight = FriendTableCell.heightForContent()

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.rx_controlEvents(.ValueChanged)
            >- subscribeNext { [unowned self] in
                if self.refreshControl!.refreshing {
                    self.refreshControl!.endRefreshing()
                    action_requestUpdateAccount(nil)
                }
            }
    }

    func loadFriendsOf(account: Account) {

        self.friendsDisposable?.dispose()

        self.friendsDisposable = River.instance.getFriendsObservable(account)
            >- subscribeNext { [unowned self] friends in
                self.refreshControl!.endRefreshing()
                self.friends = friends
                self.tableView.reloadData()
            }
    }

    // MARK: - No use

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
}
