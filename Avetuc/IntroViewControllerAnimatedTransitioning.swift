import Foundation
import UIKit
import EasyAnimation

class IntroViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    let duration: NSTimeInterval
    let isDismissing: Bool
    let introViewController: IntroViewController
    let presentingController: UIViewController

    init(introViewController: IntroViewController, presentingController: UIViewController, isDismissing: Bool) {
        self.introViewController = introViewController
        self.presentingController = presentingController
        self.isDismissing = isDismissing
        self.duration = isDismissing ? 0.3 : 0.5
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return self.duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        if !self.isDismissing {
            let backdrop: UIView = {
                let view = UIView(frame: screenBounds())
                view.backgroundColor = UIColor.blackColor()
                view.alpha = 0
                return view
            }()

            let frame = self.introViewController.view.frame

            self.introViewController.view.frame = CGRect(
                x: frame.origin.x,
                y: frame.height,
                width: frame.width,
                height: frame.height)

            transitionContext.containerView().addSubview(backdrop)
            transitionContext.containerView().addSubview(self.introViewController.view)

            UIView.animateWithDuration(
                self.duration,
                delay: 0.0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 2,
                options: nil,
                animations: {
                    let introView = self.introViewController.view as! IntroView
                    introView.layer.position.y -= introView.frame.height
                    backdrop.alpha = 1
                }) {
                    transitionContext.completeTransition($0)
                }
        }
    }

    func animationEnded(transitionCompleted: Bool) {
        println("transition ended \(transitionCompleted)")
    }
}

extension IntroViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        if let introViewController = presented as? IntroViewController {
            return IntroViewControllerAnimatedTransitioning(
                introViewController: introViewController,
                presentingController: presenting,
                isDismissing: false)
        }
        return nil
    }

    func animationControllerForDismissedController(
        dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        return nil
    }
}
