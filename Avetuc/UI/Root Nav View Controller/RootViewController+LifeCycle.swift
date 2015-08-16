import UIKit
import RxSwift

extension RootViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if self.disposable_account == nil {
            self.disposable_account = River.instance.getAccountObservable()
                >- subscribeNext { account in
                    if let account = account {
                        self.account = account
                        self.friendsTableViewController.loadFriendsOf(account)
                    }
                    else {
                        self.presentIntroView()
                    }
                }
        }
    }
}
