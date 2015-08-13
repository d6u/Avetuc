//
//  TweetTextView.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
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
