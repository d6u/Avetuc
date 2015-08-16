import UIKit
import RxSwift

extension AuthWebViewController: UIWebViewDelegate {

    func webView(
        webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType)
        -> Bool
    {
        if request.URLString.hasPrefix(TWITTER_OAUTH_CALLBACK) {
            sendNext(self.authUrlObservable, request.URL!)
            self.dismissViewControllerAnimated(true, completion: nil)
            return false
        }

        return true
    }
}
