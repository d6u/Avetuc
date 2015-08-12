import Foundation
import RxSwift
import LarryBird

func createFetchHomeTimeline(account: Account) -> Observable<Array<[String: AnyObject]>> {

    let config = configFromAccount(account)
    let requestEndpoint = requestStream(config)
    let sinceId: Int64? = account.last_fetch_since_id != -1 ? account.last_fetch_since_id : nil

    var params: [Param] = [.Count(200), .TrimUser(false), .ExcludeReplies(true), .IncludeEntities(true)]
    if let id = sinceId {
        params.append(.SinceId(String(id)))
    }

    let subject = BehaviorSubject<String?>(value: nil)

    return subject
        >- flatMap { (maxId: String?) -> Observable<AnyObject> in
            requestEndpoint(.StatusesHomeTimeline, maxId == nil ? params : params + [.MaxId(maxId!)])
        }
        >- map { data -> Array<[String: AnyObject]> in
            data as! Array<[String: AnyObject]>
        }
        >- doOnNext { arr in
            if sinceId != nil && arr.count > 0 {
                let oldestTweetId = arr.last!["id"] as! Int64
                sendNext(subject, String(oldestTweetId - 1))
            } else {
                sendCompleted(subject)
            }
        }
        >- reduce(Array<[String: AnyObject]>()) { $0 + $1 }
}
