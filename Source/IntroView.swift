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

        backgroundColor = UIColor(white: 0, alpha: 0)

        background.backgroundColor = UIColor.blackColor()
        background.alpha = 0
        background.frame = frame

        backgroundPlate.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height - 20)
        backgroundPlate.backgroundColor = UIColor.greenColor()
        backgroundPlate.layer.cornerRadius = 6
        backgroundPlate.layer.masksToBounds = true

        webAuthButton.frame = CGRect(x: 20, y: 100, width: 130, height: 200)
        iosAuthButton.frame = CGRect(x: 170, y: 100, width: 130, height: 200)

        webAuthButton.backgroundColor = UIColor.redColor()
        webAuthButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        webAuthButton.setTitle("Web Auth", forState: UIControlState.Normal)

        iosAuthButton.backgroundColor = UIColor.purpleColor()
        iosAuthButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        iosAuthButton.setTitle("iOS Auth", forState: UIControlState.Normal)

        webAuthButton.addTarget(self, action: "webAuthButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        iosAuthButton.addTarget(self, action: "iosAuthButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)

        addSubview(background)
        addSubview(backgroundPlate)
        addSubview(webAuthButton)
        addSubview(iosAuthButton)

        webAuthButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.centerX.equalTo(self.snp_centerX).multipliedBy(1.5)
            make.width.equalTo(self.snp_width).dividedBy(3)
            make.height.equalTo(300)
        }

        iosAuthButton.snp_makeConstraints { (make) -> Void in
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

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
