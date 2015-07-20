//
//  FriendCellProfileImageView.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

class ProfileImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true

        //        self.profileImageView.userInteractionEnabled = true
        //        let profileImageViewTapGestureRecongnizer = UITapGestureRecognizer(target: self, action: Selector("profileImageTapped:"))
        //        profileImageViewTapGestureRecongnizer.numberOfTapsRequired = 1
        //        self.profileImageView.addGestureRecognizer(profileImageViewTapGestureRecongnizer)
    }

    // MARK: No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}