import UIKit
import RxSwift
import M13ProgressSuite
import SnapKit
import Async

class RootViewController: UINavigationController {

    private let progress = M13ProgressViewBar()
    private var progressBarDisposable: Disposable?
    private var disposable_account: Disposable?

    private let friendsTableViewController = FriendsViewController()
    private var introViewController: IntroViewController?
    private var account: Account?

    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupProgressBar()
        self.pushViewController(self.friendsTableViewController, animated: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if self.disposable_account == nil {
            self.disposable_account = River.instance.getAccountObservable()
                >- subscribeNext { [unowned self] account in
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

    func presentIntroView() {
        self.presentViewController(IntroViewController(), animated: true, completion: nil)
    }

    func progressStarts() {
        self.progress.hidden = false
        self.progressBarDisposable = interval(0.2, MainScheduler.sharedInstance)
            >- map { (n: Int64) -> Double in
                return -pow(2, -Double(n) - 0.5) + 0.8
            }
            >- subscribeNext {
                self.progress.setProgress(CGFloat($0), animated: true)
            }
    }

    func progressEnds() {
        self.progressBarDisposable?.dispose()
        self.progressBarDisposable = nil
        self.progress.setProgress(1, animated: true)

        Async.main(after: 0.5) {
            self.progress.hidden = true
        }
    }

    func setupProgressBar() {
        self.view.addSubview(self.progress)

        self.progress.snp_makeConstraints { make in
            let navBar = self.navigationBar
            make.left.equalTo(navBar)
            make.right.equalTo(navBar).offset(10) // Mysterious offset
            make.bottom.equalTo(navBar.snp_bottom).offset(1)
        }

        self.progress.hidden = true

//        River.instance.observable_updateAccountStart
//            >- subscribeNext { _ in
//                self.progressStarts()
//        }
//
//        River.instance.observable_updateAccountFinish
//            >- subscribeNext {
//                self.progressEnds()
//        }
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
