//
//  UserNames.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class UserNames: UIView {

    init() {
        super.init(frame: CGRectZero)

        self.name.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        self.name.textColor = UIColor(netHex: 0x4A4A4A)
        self.name.numberOfLines = 1
        self.name.adjustsFontSizeToFitWidth = false

        self.screenName.font = UIFont(name: "HelveticaNeue", size: 14)
        self.screenName.textColor = UIColor(netHex: 0x979797)
        self.screenName.numberOfLines = 1
        self.screenName.adjustsFontSizeToFitWidth = false

        self.addSubview(self.name)
        self.addSubview(self.screenName)

        self.name.snp_makeConstraints { make in
            make.left.equalTo(self)
            make.bottom.equalTo(self)
        }

        self.screenName.snp_makeConstraints { make in
            make.left.equalTo(self.name.snp_right).offset(5)
            make.bottom.equalTo(self)
        }
    }

    let name = UILabel()
    let screenName = UILabel()

    func loadNames(name: String, screenName: String) {
        self.name.text = name
        self.screenName.text = "@\(screenName)"
    }

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
