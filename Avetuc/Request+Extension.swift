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

typealias Progress = (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
typealias AlamofireTask = Task<Progress, NSData, NSError>

extension Request {

    func responseAsync() -> AlamofireTask {
        return AlamofireTask { progress, fulfill, reject, configure in
            self.response { request, response, data, error in
                if let err = error {
                    reject(err)
                    return
                }
                fulfill(data as! NSData)
            }
            return
        }
    }
}
