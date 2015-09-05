import UIKit
import AsyncDisplayKit

class TweetTextNode: ASTextNode {

    var text: NSAttributedString? {
        didSet {
            if let text = self.text {
                self.attributedString = self.text!
                self.measure(CGSize(width: TWEET_CELL_TEXT_WIDTH, height: CGFloat.max))
            }
        }
    }

    override init!() {
        super.init()
        self.userInteractionEnabled = true
        self.linkAttributeNames = [TEXT_LINK_ATTR_NAME]
    }
}
