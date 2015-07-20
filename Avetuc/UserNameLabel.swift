//
//  UserNameLabel.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

class UserNameLabel: UILabel {

    init() {
        super.init(frame: CGRectZero)

        self.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        self.textColor = UIColor(netHex: 0x4A4A4A)
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = false
    }

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
