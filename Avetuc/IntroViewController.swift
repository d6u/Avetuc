//
//  IntroViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit

class IntroViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        self.view = IntroView()

        accountListener = AccountsStore.instance.on { storeData in
            if let account = storeData.cur {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }

    }

    private var accountListener: Listener?

    // MARK: - No use

    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
