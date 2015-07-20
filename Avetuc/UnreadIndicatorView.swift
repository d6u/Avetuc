//
//  UnreadIndicatorView.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

class UnreadIndicatorView: UILabel {

    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor(red: 0.129, green: 0.588, blue: 0.953, alpha: 1) // Blue
    }

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
