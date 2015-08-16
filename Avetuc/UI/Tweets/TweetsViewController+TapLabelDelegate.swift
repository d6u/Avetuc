import UIKit
import TapLabel

extension TweetsViewController: TapLabelDelegate {

    func tapLabel(tapLabel: TapLabel, didSelectLink link: String) {
        let webViewController = WebViewController(url: link)
        self.presentViewController(webViewController, animated: true, completion: nil)
    }
}
