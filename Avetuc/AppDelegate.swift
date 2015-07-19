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
    var accountListener: Listener?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
    ) -> Bool
    {
        let window = UIWindow(frame: screenBounds())

        self.window = window

        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()

        self.accountListener = AccountsStore.instance.on { event in

            // TODO: Handle account switching

            if let account = event.cur {
                FriendActions.fetchFriends(account.user_id)
                TweetsActions.fetchHomeTimeline(account.user_id, since_id: account.last_fetch_since_id)
            }
        }

        return true
    }

    func application(
        application: UIApplication, 
        openURL url: NSURL,
        sourceApplication: String?, 
        annotation: AnyObject?) -> Bool
    {
        AccountActions.handleCallbackUrl(url)
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
