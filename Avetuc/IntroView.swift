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

    override init(frame: CGRect)
    {
        self.backgroundPlate = {
            let view = UIView(frame: CGRect(x: 0, y: 20, width: frame.width, height: frame.height - 20))
            view.layer.cornerRadius = 6
            view.layer.masksToBounds = true
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor(netHex: 0x4A4A4A).CGColor, UIColor(netHex: 0x2B2B2B).CGColor]
            view.layer.insertSublayer(gradient, atIndex: 0)
            return view
        }()

        super.init(frame: frame)

        self.backgroundColor = UIColor(white: 0, alpha: 0)

        self.webAuthButton.frame = CGRect(x: 20, y: 100, width: 130, height: 200)
        self.webAuthButton.backgroundColor = UIColor.redColor()
        self.webAuthButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.webAuthButton.setTitle("Web Auth", forState: UIControlState.Normal)

        self.webAuthButton.addTarget(self, action: "webAuthButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)

        self.addSubview(self.backgroundPlate)
        self.addSubview(self.webAuthButton)

        self.webAuthButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.centerX.equalTo(self.snp_centerX).multipliedBy(1.5)
            make.width.equalTo(self.snp_width).dividedBy(3)
            make.height.equalTo(300)
        }

        River.instance.observable_addAccountError
            >- subscribeNext { err in
                println("add account err \(err)")
            }
            >- self.bag.addDisposable
    }

    let bag = DisposeBag()
    let backgroundPlate: UIView
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
