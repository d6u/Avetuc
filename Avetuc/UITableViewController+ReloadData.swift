import Foundation
import UIKit

extension UITableViewController {

    func reloadDataFrom<E>
        (updator: (cell: UITableViewCell?, diffItem: DiffItem<E>, indexPath: NSIndexPath) -> Void)
        (diffResult: DiffResult<E>)
    {
        self.tableView.beginUpdates()

        let insertIndexPaths = diffResult.added.map { NSIndexPath(forRow: $0.index, inSection: 0) }
        self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Bottom)

        let deleteIndexPaths = diffResult.removed.map { NSIndexPath(forRow: $0.index, inSection: 0) }
        self.tableView.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Bottom)

        for item in diffResult.updated {
            let indexPath = NSIndexPath(forRow: item.index, inSection: 0)
            updator(
                cell: self.tableView.cellForRowAtIndexPath(indexPath),
                diffItem: item,
                indexPath: indexPath)
        }

        for item in diffResult.moved {
            self.tableView.moveRowAtIndexPath(
                NSIndexPath(forRow: item.previousIndex, inSection: 0),
                toIndexPath: NSIndexPath(forRow: item.newIndex, inSection: 0))
        }

        self.tableView.endUpdates()
    }

}
