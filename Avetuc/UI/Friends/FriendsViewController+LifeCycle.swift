import UIKit

extension FriendsViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow() {
            self.tableView.deselectRowAtIndexPath(selectedRowIndexPath, animated: true)
        }
    }
}
