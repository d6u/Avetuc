import UIKit

extension TweetsViewController: UITableViewDataSource {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! TweetCell
        cell.textView.delegate = self
        cell.loadTweet(self.tweets[indexPath.row], user: self.user)
        return cell
    }
}

extension TweetsViewController: UITableViewDelegate {
}
