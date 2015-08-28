import UIKit
import SnapKit

class FriendCellUnreadCountView: UIView {

    init() {
        super.init(frame: CGRectZero)

        self.label.font = UIFont(name: "HelveticaNeue", size: 17)
        self.label.textAlignment = .Center
        self.label.backgroundColor = UIColor.whiteColor()

        self.addSubview(self.label)

        self.label.snp_makeConstraints { make in
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(3, 5, 3, 5))
        }
    }

    let label = UILabel()

    var count: Int64? {
        didSet {
            if let c = self.count {
                self.label.text = c > 0 ? String(c) : ""
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}