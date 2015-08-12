import Foundation
import RxSwift

class CommonScheduler {

    static let instance: SerialDispatchQueueScheduler = {
        return SerialDispatchQueueScheduler(
            queue: dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0),
            internalSerialQueueName: "common_background")
    }()

}
