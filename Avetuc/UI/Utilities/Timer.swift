//
//  Timer.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/26/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Async

class Timer {

    let block: Async

    init(duration: Double, block: () -> Void) {
        self.block = Async.main(after: duration, block: block)
    }

    deinit {
        self.block.cancel()
    }

}
