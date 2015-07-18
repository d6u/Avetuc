//
//  Request+Extension.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/14/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftTask

typealias RequestTask = Task<Float, NSData, NSError>

extension Request {
    func response() -> RequestTask {
        return RequestTask { progress, fulfill, reject, configure -> Void in
            self.response { request, response, data, error in
                error != nil ? reject(error!) : fulfill(data as! NSData)
            }
            return // Must return to make SwiftTask happen when compile
        }
    }
}
