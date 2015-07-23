//
//  AppDelegate.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import UIKit
import CoreStore
import EmitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        self.window = UIWindow(frame: screenBounds())
        self.window!.rootViewController = RootViewController()
        self.window!.makeKeyAndVisible()
        return true
    }

    func application(
        application: UIApplication, 
        openURL url: NSURL,
        sourceApplication: String?, 
        annotation: AnyObject?) -> Bool
    {
        handleCallbackUrl(url)
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

    func applicationWillTerminate(application: UIApplication) {
    }

}
