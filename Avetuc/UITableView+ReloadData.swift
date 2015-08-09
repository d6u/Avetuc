import Foundation
import UIKit

extension UITableView {

    func reloadDataFrom<E>(diffResult: DiffResult<E>) {
        self.beginUpdates()

        println("added \(diffResult.added.count)")
        println("updated \(diffResult.updated.count)")
        println("moved \(diffResult.moved.count)")
        println("removed \(diffResult.removed.count)")

        let insertIndexPaths = diffResult.added.map { NSIndexPath(forRow: $0.index, inSection: 0) }
        self.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Bottom)

        let deleteIndexPaths = diffResult.removed.map { NSIndexPath(forRow: $0.index, inSection: 0) }
        self.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Bottom)

        let updateIndexPaths = diffResult.updated.map { NSIndexPath(forRow: $0.index, inSection: 0) }
        self.reloadRowsAtIndexPaths(updateIndexPaths, withRowAnimation: .None)

        for item in diffResult.moved {
            self.moveRowAtIndexPath(
                NSIndexPath(forRow: item.previousIndex, inSection: 0),
                toIndexPath: NSIndexPath(forRow: item.newIndex, inSection: 0))
        }

        self.endUpdates()
    }

}
