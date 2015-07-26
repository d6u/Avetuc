//
//  FriendCellUnreadCountView.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FriendCellUnreadCountView: UIView {

    init() {
        super.init(frame: CGRectZero)

        self.backgroundColor = UNREAD_COUNT_BACKGROUND_COLOR
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true

        self.label.textColor = UIColor.whiteColor()
        self.label.font = UIFont(name: "HelveticaNeue", size: 15)
        self.label.textAlignment = .Center

        self.addSubview(self.label)

        self.label.snp_makeConstraints { make in
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(3, 5, 3, 5))
        }
    }

    let label = UILabel()

    var count: Int64? {
        didSet {
            if let c = self.count {
                self.label.text = String(c)
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}