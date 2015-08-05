import UIKit

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
        action_handleOauthCallback(url)
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
