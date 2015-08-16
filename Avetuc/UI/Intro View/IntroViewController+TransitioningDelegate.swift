import UIKit

extension IntroViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        if let introViewController = presented as? IntroViewController {
            return IntroViewControllerAnimatedTransitioning(introViewController: introViewController, isDismissing: false)
        }
        return nil
    }

    func animationControllerForDismissedController(
        dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        if let introViewController = dismissed as? IntroViewController {
            return IntroViewControllerAnimatedTransitioning(introViewController: introViewController, isDismissing: true)
        }
        return nil
    }
}
