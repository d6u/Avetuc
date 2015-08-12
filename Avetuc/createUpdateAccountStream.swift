import Foundation
import RxSwift
import RealmSwift

func createUpdateAccountStream(account: Account) -> Observable<()> {
//    let updateFriendsStream = createUpdateFriendsStream(account)
//        >- catch { err in
//            let account = Realm().objects(AccountModel).filter("user_id = %@", account.user_id).first!
//            return just(Array(account.friends).map { $0.toData() })
//        }

    let fetchHomeTimeline = createFetchHomeTimeline(account)
        >- catch(Array<[String: AnyObject]>())

    return fetchHomeTimeline
        >- map { arr in
            if arr.count == 0 {
                return
            }

            let realm = Realm()

            realm.beginWrite()

            let tweets = arr.map { data -> Tweet in
                let tweet = realm.create(Tweet.self, value: data, update: true)
                tweet.user.unread_status_count += 1
                return tweet
            }

            let account = realm.objects(Account).filter("user_id = %@", account.user_id).first!

            for var i = tweets.count - 1; i >= 0; i-- {
                account.home_timeline.insert(tweets[i], atIndex: 0)
            }

            account.last_fetch_since_id = tweets.first!.id

            realm.commitWrite()
        }
}
