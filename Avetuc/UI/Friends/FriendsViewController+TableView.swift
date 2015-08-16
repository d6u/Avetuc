import UIKit

extension FriendsViewController: UITableViewDataSource {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER,
            forIndexPath: indexPath)
            as! FriendTableCell
        cell.load(self.friends[indexPath.row])
        return cell
    }
}

extension FriendsViewController: UITableViewDelegate {

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FriendTableCell.heightForContent()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.friends[indexPath.row]
        let tweetViewController = TweetsViewController(user: user)
        self.navigationController!.pushViewController(tweetViewController, animated: true)
    }
}
