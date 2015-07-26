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
            self.validate().response { request, response, data, error in
                if let err = error {
                    println("Bad request \(response!.statusCode) body: \(NSString(data: data!, encoding: NSUTF8StringEncoding)) error: \(err)")
                    reject(err)
                } else {
                    fulfill(data!)
                }
            }
            return // Must return to make SwiftTask happen when compile
        }
    }
}
