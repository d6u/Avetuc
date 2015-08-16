import UIKit
import RxSwift
import M13ProgressSuite
import SnapKit
import Async

extension RootViewController {

    func setupProgressBar() {
        self.view.addSubview(self.progress)

        self.progress.snp_makeConstraints { make in
            let navBar = self.navigationBar
            make.left.equalTo(navBar)
            make.right.equalTo(navBar).offset(10) // Mysterious offset
            make.bottom.equalTo(navBar.snp_bottom).offset(1)
        }

        self.progress.hidden = true

        River.instance.action_requestUpdateAccount
            >- subscribeNext { _ in
                self.progressStarts()
            }

        River.instance.getUpdateAccountObservable()
            >- subscribeNext {
                self.progressEnds()
            }
    }
    
    func progressStarts() {
        self.progress.hidden = false

        self.progressBarDisposable = interval(0.2, MainScheduler.sharedInstance)
            >- map { (n: Int64) -> Double in
                return -pow(2, -Double(n) - 0.5) + 0.8
            }
            >- subscribeNext {
                self.progress.setProgress(CGFloat($0), animated: true)
            }
    }

    func progressEnds() {
        self.progressBarDisposable?.dispose()
        self.progressBarDisposable = nil
        self.progress.setProgress(1, animated: true)

        Async.main(after: 0.5) {
            self.progress.hidden = true
        }
    }
}
