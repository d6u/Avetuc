//
//  IntroViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

class IntroViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Delegate

    override func loadView() {
        self.view = IntroView()
    }

    // MARK: - No use

    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
