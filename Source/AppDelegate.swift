//
//  AppDelegate.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import UIKit
import CoreStore
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        let window = UIWindow(frame: screenBounds())

        self.window = window

        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()

        let api = TwitterApi(consumerKey: "t438xJ7yjwTWn7MeW2tH9Q", consumerSecret: "AVtSkceC0eB4eiTYRXJzemqJTRNhF2JWGV9Ax5K0Pw0")

        api.fetch(.OauthRequestToken, params: .OauthCallback("avetuc://twitter_callback"))

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication)
    {
        CoreStore.beginSynchronous { (transaction) -> Void in
            transaction.commit()
        }
    }

}
