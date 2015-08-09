import Foundation
import RxSwift
import LarryBird
import Argo

func createFetchHomeTimeline(account: Account) -> Observable<[TweetApiData]> {

    let config = configFromAccount(account)
    let requestEndpoint = requestStream(config)
    let sinceId = account.last_fetch_since_id

    var params: [Param] = [.Count(200), .TrimUser(false), .ExcludeReplies(true), .IncludeEntities(true)]
    if let id = sinceId {
        params.append(.SinceId(String(id)))
    }

    let subject = BehaviorSubject<String?>(value: nil)

    return subject
        >- flatMap { (maxId: String?) -> Observable<AnyObject> in
            requestEndpoint(.StatusesHomeTimeline, maxId == nil ? params : params + [.MaxId(maxId!)])
        }
        >- map { apiData -> [TweetApiData] in
            let data: [TweetApiData]? = decode(apiData)
            return data!
        }
        >- doOnNext { data in
            if sinceId != nil && data.count > 0 {
                let oldestTweetId = data.last!.id
                sendNext(subject, String(oldestTweetId - 1))
            } else {
                sendCompleted(subject)
            }
        }
        >- reduce([TweetApiData]()) { $0 + $1 }
}
