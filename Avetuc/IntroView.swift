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

        self.logoImage = UIImage(named: "LetterA")!
        self.logo = UIImageView(image: self.logoImage)

        self.webAuthButton = {
            let button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            button.backgroundColor = UIColor(netHex: 0x787878)
            let title = NSAttributedString(string: "Sign in with Twitter", attributes: [
                NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!,
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ])
            button.setAttributedTitle(title, forState: .Normal)
            button.layer.cornerRadius = 6
            button.layer.masksToBounds = true
            return button
        }()

        super.init(frame: frame)

        self.backgroundColor = UIColor(white: 0, alpha: 0)

        self.webAuthButton.addTarget(self, action: "webAuthButtonTapped", forControlEvents: .TouchUpInside)

        self.addSubview(self.backgroundPlate)
        self.addSubview(self.logo)
        self.addSubview(self.webAuthButton)

        self.logo.snp_makeConstraints { make in
            make.top.equalTo(160)
            make.centerX.equalTo(self)
        }

        self.webAuthButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self.logo.snp_bottom).offset(120)
            make.width.equalTo(250)
            make.height.equalTo(50)
        }

        River.instance.observable_addAccountError
            >- subscribeNext { err in
                println("add account err \(err)")
            }
            >- self.bag.addDisposable
    }

    let bag = DisposeBag()
    let backgroundPlate: UIView
    let webAuthButton: UIButton
    let logoImage: UIImage
    let logo: UIImageView

    func webAuthButtonTapped() {
        action_addAccountFromWeb()
    }

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
