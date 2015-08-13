import Foundation
import UIKit
import RxSwift
import M13ProgressSuite
import SnapKit
import Async

class RootViewController: UINavigationController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    let bag = DisposeBag()
    let progress = M13ProgressViewBar()
    var progressBarDisposable: Disposable?
    var disposable_account: Disposable?

    let friendsTableViewController = FriendsViewController()
    var introViewController: IntroViewController?
    var account: Account?

    func presentIntroView() {
        self.introViewController = IntroViewController()
        self.presentViewController(self.introViewController!, animated: true, completion: nil)
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

    // MARK: - Delegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(self.friendsTableViewController, animated: false)

        self.view.addSubview(self.progress)

        let navBar = self.navigationBar

        self.progress.snp_makeConstraints { make in
            make.left.equalTo(navBar)
            make.right.equalTo(navBar).offset(10) // Mysterious offset
            make.bottom.equalTo(navBar.snp_bottom).offset(1)
        }

        self.progress.hidden = true

        River.instance.observable_updateAccountStart
            >- subscribeNext { _ in
                self.progressStarts()
            }

        River.instance.observable_updateAccountFinish
            >- subscribeNext {
                self.progressEnds()
            }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if self.disposable_account == nil {
            self.disposable_account = River.instance.observable_account
                >- subscribeNext { [unowned self] account in
                    if let account = account {
                        self.account = account

                        if let intro = self.introViewController {
                            action_updateAccount(account.user_id)
                            intro.dismissViewControllerAnimated(true, completion: nil)
                            self.introViewController = nil
                        }

                    }
                    else {
                        self.presentIntroView()
                    }
                }

            self.bag.addDisposable(self.disposable_account!)
        }
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
