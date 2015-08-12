import Foundation
import RxSwift

class CommonScheduler {

    static let instance: SerialDispatchQueueScheduler = {
        return SerialDispatchQueueScheduler(
            queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
            internalSerialQueueName: "common_background")
    }()

}
