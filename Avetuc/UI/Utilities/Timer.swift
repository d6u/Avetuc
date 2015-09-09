import Foundation
import Async

class Timer {

    let block: Async

    init(duration: Double, block: () -> Void) {
        self.block = Async.main(after: duration, block: block)
    }

    deinit {
        self.block.cancel()
    }

}
