import UIKit
import SnapKit
import RxSwift
import RxCocoa

class IntroView: UIView {

    private let backgroundPlate: UIView
    let webAuthButton: UIButton
    private let logo: UIImageView

    override init(frame: CGRect)
    {
        self.logo = UIImageView(image: UIImage(named: "LetterA")!)

        self.backgroundPlate = {
            let view = UIView(frame: CGRect(x: 0, y: 20, width: frame.width, height: frame.height - 20))
            view.layer.cornerRadius = 6
            view.layer.masksToBounds = true
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor(netHex: 0x4A4A4A).CGColor, UIColor(netHex: 0x2B2B2B).CGColor]
            view.layer.insertSublayer(gradient, atIndex: 0)
            return view
        }()

        self.webAuthButton = {
            let button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            button.backgroundColor = UIColor(netHex: 0x787878)
            let title = NSAttributedString(string: "Sign in with Twitter", attributes: [
                NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)!,
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ])
            button.setAttributedTitle(title, forState: .Normal)
            button.layer.cornerRadius = 6
            button.layer.masksToBounds = true
            return button
        }()

        super.init(frame: frame)

        self.backgroundColor = UIColor(white: 0, alpha: 0)

        self.addSubview(self.backgroundPlate)
        self.addSubview(self.logo)
        self.addSubview(self.webAuthButton)

        self.logo.snp_makeConstraints { make in
            make.top.equalTo(160)
            make.centerX.equalTo(self)
        }

        self.webAuthButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self.logo.snp_bottom).offset(90)
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
    }

    // MARK: - No use

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
