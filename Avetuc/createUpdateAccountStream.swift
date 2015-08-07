import Foundation
import RxSwift
import LarryBird
import Argo
import RealmSwift

func createUpdateAccountStream(accountSubject: Observable<Account>) -> ConnectableObservableType<Void> {
    return accountSubject >- flatMap { (account: Account) -> Observable<Void> in
        return create { (observer: ObserverOf<Void>) in

            let s = zip(createUpdateFriendsStream(account), createFetchHomeTimeline(account)) {
                (users: [User], tweetApiData: [TweetApiData]) -> Observable<Int> in

                

                return empty()
            } >- publish

            s.connect()

            return AnonymousDisposable {}
        }
    }
    >- publish
}
