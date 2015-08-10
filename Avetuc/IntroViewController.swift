import Foundation
import UIKit

class IntroViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
    }

    // MARK: - Delegate

    override func loadView() {
        self.view = IntroView(frame: screenBounds())
    }

    // MARK: - No use

    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
