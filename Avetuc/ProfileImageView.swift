//
//  FriendCellProfileImageView.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ProfileImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(netHex: 0xCDCDCD).CGColor
        self.layer.borderWidth = 1
    }

    func updateImage(url: String) {
        self.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: nil)
    }

    // MARK: No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}