//
//  TimestampView.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

class TimestampView: UILabel {

    init() {
        super.init(frame: CGRectZero)

        self.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        self.textColor = UIColor(netHex: 0x979797)
    }

    // MARK: - No use

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
