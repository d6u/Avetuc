import UIKit
import RxSwift
import DZNEmptyDataSet

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

    func reloadTable(diffResult: DiffResult<User>)
    {
        switch diffResult {
        case .Initial(let friends):
            #if DEBUG
                println("friends table initial load")
            #endif

            self.tableView.reloadData()
        case .Differences(let differences):
            #if DEBUG
                println("friends table diff load")
                println(differences)
            #endif

            self.tableView.beginUpdates()

            let insertIndexPaths = differences.insert.map { NSIndexPath(forRow: $0.index, inSection: 0) }
            self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Bottom)

            let removeIndexPaths = differences.remove.map { NSIndexPath(forRow: $0.index, inSection: 0) }
            self.tableView.deleteRowsAtIndexPaths(removeIndexPaths, withRowAnimation: .Bottom)

            let updateIndexPaths = differences.update.map { NSIndexPath(forRow: $0.index, inSection: 0) }
            self.tableView.reloadRowsAtIndexPaths(updateIndexPaths, withRowAnimation: .Fade)

            for item in differences.move {
                let indexPath = NSIndexPath(forRow: item.oldIndex, inSection: 0)

                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? FriendTableCell {
                    cell.refresh()
                }

                self.tableView.moveRowAtIndexPath(
                    indexPath,
                    toIndexPath: NSIndexPath(forRow: item.newIndex, inSection: 0))
            }

            self.tableView.endUpdates()
        }
    }

    // MARK: - View Delegate

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(
            self,
            action: Selector("refreshControlValueChanged:"),
            forControlEvents: .ValueChanged)

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()

        River.instance.observable_friends
            >- subscribeNext { [unowned self] (friends, diffResult) in
                self.refreshControl!.endRefreshing()
                self.friends = friends
                self.reloadTable(diffResult)
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

extension FriendsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Loading friends...")
    }
}
