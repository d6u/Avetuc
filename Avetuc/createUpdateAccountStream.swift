import Foundation
import RxSwift
import LarryBird
import Argo
import RealmSwift

func createUpdateAccountStream(accountSubject: Observable<Account>) -> ConnectableObservableType<Void> {
    return accountSubject >- flatMap { (account: Account) -> Observable<Void> in
        return create { (observer: ObserverOf<Void>) in

            let updateFriendsStream = createUpdateFriendsStream(account)

            let config = configFromAccount(account)

            let fetchHomeTimelineStream = requestStream(config)(.StatusesHomeTimeline, [.UserId(account.user_id), .Count(5000), .StringifyIds(true)])

//                >- subscribe(
//                    next: {
//                        println("next \($0.map { $0.id })")
//                    },
//                    error: {
//                        println("error \($0)")
//                    },
//                    completed: { sendNext(observer, ()) })

            return AnonymousDisposable {}
        }
    }
    >- publish
}
