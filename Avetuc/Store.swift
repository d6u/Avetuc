//
//  Store.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask

protocol Store {
    typealias T
    typealias U
    func perform(T) -> Task<Int, U, NSError>
}
