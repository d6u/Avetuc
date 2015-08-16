import UIKit

extension TweetsViewController: UIScrollViewDelegate {

    override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        // This method will be triggered twice before `viewDidAppear`,
        // which causes funny memory retain issues when calling `visibleCells`
        // Set this flag to prevent it being called before `viewDidAppear`
        if !self.isMonitoringScroll {
            return
        }

        let offset = scrollView.contentOffset.y + 64 // Top offset
        let containerHeight = scrollView.frame.height - 64

        for cell in self.tableView.visibleCells() as! [TweetCell]
        {
            if let cellData = cell.cellData where !cellData.tweet.is_read
            {
                let bottom = cell.frame.origin.y + cell.frame.height

                if bottom < offset {
                    action_updateTweetReadState(cellData.tweet, true)
                }
                else if bottom - offset <= containerHeight {
                    cell.setMakeReadTimer()
                }
                else if bottom - offset > containerHeight {
                    cell.cancelMakeReadTimer()
                }
            }
        }
    }
}
