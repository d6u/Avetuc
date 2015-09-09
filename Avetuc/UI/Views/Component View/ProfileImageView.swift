import UIKit
import Kingfisher

class ProfileImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }

    func updateImage(url: String) {
        let biggerUrl = url.stringByReplacingOccurrencesOfString("normal", withString: "bigger")
        self.kf_setImageWithURL(NSURL(string: biggerUrl)!, placeholderImage: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}