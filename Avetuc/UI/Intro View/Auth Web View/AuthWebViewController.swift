import Foundation
import UIKit
import RxSwift
import RxCocoa

class AuthWebViewController: UIViewController {

    private let bag = DisposeBag()
    private let browser = UIWebView()

    let authUrlObservable = PublishSubject<NSURL>()

    init(url: NSURL) {
        super.init(nibName: nil, bundle: nil)

        self.browser.frame = self.view.bounds
        self.browser.scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.browser.loadRequest(NSURLRequest(URL: url))
        self.browser.delegate = self

        let leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .Plain,
            target: nil,
            action: nil)

        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = leftBarButtonItem
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64))
        navigationBar.items = [navigationItem]

        self.view.addSubview(self.browser)
        self.view.addSubview(navigationBar)

        leftBarButtonItem.rx_tap
            >- subscribeNext { [unowned self] in
                self.dismissViewControllerAnimated(true, completion: nil)
                sendError(self.authUrlObservable, UnknownError)
            }
            >- self.bag.addDisposable
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
