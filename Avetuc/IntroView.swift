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
import RxSwift

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
        self.webAuthButton.backgroundColor = UIColor.redColor()
        self.webAuthButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.webAuthButton.setTitle("Web Auth", forState: UIControlState.Normal)

        self.webAuthButton.addTarget(self, action: "webAuthButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)

        self.addSubview(self.background)
        self.addSubview(self.backgroundPlate)
        self.addSubview(self.webAuthButton)

        self.webAuthButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.centerX.equalTo(self.snp_centerX).multipliedBy(1.5)
            make.width.equalTo(self.snp_width).dividedBy(3)
            make.height.equalTo(300)
        }

        River.instance.stream_addAccountError
            >- subscribeNext { err in
                println("add account err \(err)")
            }
            >- self.bag.addDisposable
    }

    let bag = DisposeBag()
    let background = UIView()
    let backgroundPlate = UIView()
    let webAuthButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let cancelButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton

    func webAuthButtonTapped() {
        action_addAccountFromWeb()
    }

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
