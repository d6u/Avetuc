//
//  UnreadIndicator.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/26/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

class UnreadIndicator: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor(netHex: 0x549AE6)
        self.layer.mask = {
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: 15, y: 0))
            path.addLineToPoint(CGPoint(x: 0, y: 15))
            path.addLineToPoint(CGPoint(x: 0, y: 0))
            let mask = CAShapeLayer()
            mask.frame = self.bounds
            mask.path = path.CGPath
            return mask
        }()
    }

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
