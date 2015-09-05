import UIKit
import TapLabel
import AsyncDisplayKit

extension TweetsViewController: ASTextNodeDelegate {

    func textNode(
        textNode: ASTextNode!,
        tappedLinkAttribute attribute: String!,
        value: AnyObject!,
        atPoint point: CGPoint,
        textRange: NSRange)
    {
        println(attribute)
        println(value)
    }

    func textNode(
        textNode: ASTextNode!,
        shouldHighlightLinkAttribute attribute: String!,
        value: AnyObject!,
        atPoint point: CGPoint) -> Bool
    {
        println(attribute)
        return true
    }
}
