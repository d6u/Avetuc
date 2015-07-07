//
//  LocalStoreService.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/7/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

class LocalStoreService {

    class var instance: LocalStoreService {
        struct Static {
            static var instance: LocalStoreService?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = LocalStoreService()
        }
        return Static.instance!
    }

    

}
