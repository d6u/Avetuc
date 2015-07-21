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
    }

    private var accountListener: Listener?

    override func loadView() {
        self.view = IntroView()
    }

    override func viewDidLoad() {
        self.accountListener = AccountsStore.instance.on { [unowned self] storeData in
            if storeData.cur != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    // MARK: - No use

    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
