import Foundation
import UIKit
import EasyAnimation

class IntroViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    let duration: NSTimeInterval
    let isDismissing: Bool
    let introViewController: IntroViewController

    init(introViewController: IntroViewController, isDismissing: Bool) {
        self.introViewController = introViewController
        self.isDismissing = isDismissing
        self.duration = isDismissing ? 0.3 : 0.5
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
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
                options: [],
                animations: {
                    let introView = self.introViewController.view as! IntroView
                    introView.layer.position.y -= introView.frame.height
                    backdrop.alpha = 1
                }) {
                    self.introViewController.view.backgroundColor = UIColor(white: 0, alpha: 1)
                    backdrop.removeFromSuperview()
                    transitionContext.completeTransition($0)
                }
        }
        else {
            let backdrop: UIView = {
                let view = UIView(frame: screenBounds())
                view.backgroundColor = UIColor.blackColor()
                view.alpha = 1
                return view
            }()

            let frame = self.introViewController.view.frame

            transitionContext.containerView().insertSubview(backdrop, belowSubview: self.introViewController.view)
            self.introViewController.view.backgroundColor = UIColor(white: 0, alpha: 0)

            UIView.animateWithDuration(
                self.duration,
                delay: 0,
                options: .CurveEaseIn,
                animations: {
                    let introView = self.introViewController.view as! IntroView
                    introView.layer.position.y += introView.frame.height
                    backdrop.alpha = 0
                }) {
                    transitionContext.completeTransition($0)
                    backdrop.removeFromSuperview()
                }
        }
    }
}
