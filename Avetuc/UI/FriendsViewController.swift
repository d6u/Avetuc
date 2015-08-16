import UIKit
import RxSwift

class FriendsViewController: UITableViewController {

    private var friendsDisposable: Disposable?
    private(set) var friends = [User]()

    init() {
        super.init(nibName: nil, bundle: nil)

        self.tableView.registerClass(FriendTableCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        self.tableView.layoutMargins = UIEdgeInsetsZero

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
//                self.reloadTable(diffResult)
            }
    }

//    func reloadTable(diffResult: DiffResult<User>)
//    {
//        switch diffResult {
//        case .Initial(let friends):
//            #if DEBUG
//                println("friends table initial load")
//            #endif
//
//            self.tableView.reloadData()
//        case .Differences(let differences):
//            #if DEBUG
//                println("friends table diff load")
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
//            let updateIndexPaths = differences.update.map { NSIndexPath(forRow: $0.index, inSection: 0) }
//            self.tableView.reloadRowsAtIndexPaths(updateIndexPaths, withRowAnimation: .Fade)
//
//            for item in differences.move {
//                let indexPath = NSIndexPath(forRow: item.oldIndex, inSection: 0)
//
//                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? FriendTableCell {
//                    cell.refresh()
//                }
//
//                self.tableView.moveRowAtIndexPath(
//                    indexPath,
//                    toIndexPath: NSIndexPath(forRow: item.newIndex, inSection: 0))
//            }
//
//            self.tableView.endUpdates()
//        }
//    }

    // MARK: - No use

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
}
