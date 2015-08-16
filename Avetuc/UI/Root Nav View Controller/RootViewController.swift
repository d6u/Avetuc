import UIKit
import RxSwift
import M13ProgressSuite
import SnapKit
import Async

class RootViewController: UINavigationController {

    let progress = M13ProgressViewBar()
    var progressBarDisposable: Disposable?
    var disposable_account: Disposable?

    let friendsTableViewController = FriendsViewController()
    private var introViewController: IntroViewController?
    var account: Account?

    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupProgressBar()
        self.pushViewController(self.friendsTableViewController, animated: false)
    }

    func presentIntroView() {
        self.presentViewController(IntroViewController(), animated: true, completion: nil)
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
