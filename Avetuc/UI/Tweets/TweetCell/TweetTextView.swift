import UIKit
import TapLabel

class TweetTextView: TapLabel {

    init() {
        super.init(frame: CGRectZero)

        self.numberOfLines = 0
        self.lineBreakMode = .ByWordWrapping
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
