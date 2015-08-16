import UIKit
import BRYXBanner
import RxSwift
import RealmSwift

class IntroViewController: UIViewController {

    let bag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)

        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
    }

    override func loadView() {
        let view = IntroView(frame: screenBounds())

        view.webAuthButton.rx_tap
            >- doOnNext {
                view.webAuthButton.enabled = false
                view.webAuthButton.alpha = 0.5
            }
            >- flatMap { _ in
                requestWebAuthUrlStream(defaultConfig())(TWITTER_OAUTH_CALLBACK)
            }
            >- flatMap { [unowned self] (data: [String: String], url: NSURL) -> Observable<Observable<AnyObject>> in
                let s1 = just(configFromRequestTokenData(data))
                let s2 = self.openWebView(url)
                return combineLatest(s1, s2) { requestAccessTokenStream($0)($1) }
            }
            >- flattern
            >- `do` { _ in
                view.webAuthButton.enabled = true
                view.webAuthButton.alpha = 1
            }
            >- doOnError { [unowned self] _ in
                self.showError("Please try again")
            }
            >- retry
            >- subscribeNext { [unowned self] data in
                let realm = Realm()
                var account: Account!
                realm.write {
                    account = realm.create(Account.self, value: data, update: true)
                }

                action_addAccount(account)
                action_requestUpdateAccount(account.user_id)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            >- self.bag.addDisposable

        self.view = view
    }

    func openWebView(url: NSURL) -> Observable<NSURL> {
        let view = AuthWebViewController(url: url)
        self.presentViewController(view, animated: true, completion: nil)
        return view.authUrlObservable
    }

    func showError(message: String) {
        let banner = Banner(
            title: "Something was wrong",
            subtitle: message,
            image: nil,
            backgroundColor: UIColor(hex: 0xD82602))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }

    // MARK: - No use

    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
