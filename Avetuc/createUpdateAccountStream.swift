import Foundation
import RxSwift
import LarryBird
import Argo
import RealmSwift

func createUpdateAccountStream(accountSubject: Observable<Account>) -> ConnectableObservableType<Void>
{
    return accountSubject >- flatMap { (account: Account) -> Observable<Void> in

        return create { (observer: ObserverOf<Void>) in

            let updateFriendsStream = createUpdateFriendsStream(account)
                >- catch { err in
                    let realm = Realm()
                    let accountModel = realm.objects(AccountModel).filter("user_id = %@", account.user_id).first!
                    return just(Array(accountModel.friends).map { $0.toData() })
                }

            let fetchHomeTimeline = createFetchHomeTimeline(account)
                >- catch([TweetApiData]())

            zip(updateFriendsStream, fetchHomeTimeline) { (users: [User], tweetsApiData: [TweetApiData]) -> Void in
                println("new tweets count \(tweetsApiData.count)")
                if tweetsApiData.count == 0 {
                    return
                }

                let realm = Realm()
                let accountModel = realm.objects(AccountModel).filter("user_id = %@", account.user_id).first!
                var tweets = [Tweet]()

                realm.write {
                    for d in tweetsApiData {
                        let tweetModel = TweetModel().fromApiData(d)
                        let retweeted = tweetModel.retweeted_status

                        if let t = retweeted {
                            realm.add(t, update: true)

                            if let user = realm.objects(UserModel).filter("id = %ld", d.retweeted_status!.user.id).first {
                                user.statuses.append(t)
                            } else {
                                let user = UserModel().fromApiData(d.retweeted_status!.user)
                                user.statuses.append(t)
                                realm.add(user, update: true)
                            }
                        }

                        realm.add(tweetModel, update: true)

                        let user = accountModel.friends.filter("id = %ld", d.user.id).first!
                        user.statuses.append(tweetModel)
                        user.unread_status_count += 1
                        
                        tweets.append(tweetModel.toData())
                    }

                    accountModel.last_fetch_since_id = tweets.first!.id
                }
            } >- subscribe(
                next: { println("next \($0)") },
                error: { println("error \($0)") },
                completed: {
                    println("completed")
                    sendNext(observer, ())
                })

            return AnonymousDisposable {}
        }
    }
    >- publish
}
