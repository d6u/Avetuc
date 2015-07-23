//
//  IntroView.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class IntroView: UIView {

    init() {
        super.init(frame: CGRectZero)

        self.backgroundColor = UIColor(white: 0, alpha: 0)

        self.background.backgroundColor = UIColor.blackColor()
        self.background.alpha = 0
        self.background.frame = frame

        self.backgroundPlate.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height - 20)
        self.backgroundPlate.backgroundColor = UIColor.greenColor()
        self.backgroundPlate.layer.cornerRadius = 6
        self.backgroundPlate.layer.masksToBounds = true

        self.webAuthButton.frame = CGRect(x: 20, y: 100, width: 130, height: 200)
        self.iosAuthButton.frame = CGRect(x: 170, y: 100, width: 130, height: 200)

        self.webAuthButton.backgroundColor = UIColor.redColor()
        self.webAuthButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.webAuthButton.setTitle("Web Auth", forState: UIControlState.Normal)

        self.iosAuthButton.backgroundColor = UIColor.purpleColor()
        self.iosAuthButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.iosAuthButton.setTitle("iOS Auth", forState: UIControlState.Normal)

        self.webAuthButton.addTarget(self, action: "webAuthButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        self.iosAuthButton.addTarget(self, action: "iosAuthButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)

        self.addSubview(self.background)
        self.addSubview(self.backgroundPlate)
        self.addSubview(self.webAuthButton)
        self.addSubview(self.iosAuthButton)

        self.webAuthButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.centerX.equalTo(self.snp_centerX).multipliedBy(1.5)
            make.width.equalTo(self.snp_width).dividedBy(3)
            make.height.equalTo(300)
        }

        self.iosAuthButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.centerX.equalTo(self.snp_centerX).multipliedBy(0.5)
            make.width.equalTo(self.snp_width).dividedBy(3)
            make.height.equalTo(300)
        }
    }

    let background = UIView()
    let backgroundPlate = UIView()
    let webAuthButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let iosAuthButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let cancelButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton

    func webAuthButtonTapped() {
        addAccountThroughWeb()
    }

    func iosAuthButtonTapped() {

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
