import UIKit
import AsyncDisplayKit

extension TweetsViewController: ASTextNodeDelegate {

    func textNode(
        textNode: ASTextNode!,
        tappedLinkAttribute attribute: String!,
        value: AnyObject!,
        atPoint point: CGPoint,
        textRange: NSRange)
    {
        if attribute == TEXT_LINK_ATTR_NAME {
            let webViewController = WebViewController(url: value as! String)
            self.presentViewController(webViewController, animated: true, completion: nil)
        }
    }

    func textNode(
        textNode: ASTextNode!,
        shouldHighlightLinkAttribute attribute: String!,
        value: AnyObject!,
        atPoint point: CGPoint) -> Bool
    {
        return true
    }
}
