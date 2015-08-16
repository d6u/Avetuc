import UIKit
import DZNEmptyDataSet

extension FriendsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Loading friends...")
    }
}
