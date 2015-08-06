import Foundation
import RxSwift
import LarryBird
import Argo
import RealmSwift

func createUpdateAccountStream(accountSubject: Observable<Account>) -> ConnectableObservableType<Void> {
    return accountSubject >- flatMap { (account: Account) -> Observable<Void> in
        println(account.user_id)
        return create { (observer: ObserverOf<Void>) in

            let config = configFromAccount(account)

            requestStream(config)(.FriendsIds, [.UserId(account.user_id), .Count(5000), .StringifyIds(true)])
                >- map { data -> [String] in
                    let friendsIds: FriendsIdsData? = decode(data)
                    return friendsIds!.ids
                }
                >- doOnNext { ids in
                    println(ids)
                    let realm = Realm()
                    let accountModel = realm.objects(AccountModel).filter("user_id = %@", account.user_id).first!
                    for friend in accountModel.friends {
                        if !contains(ids, friend.id_str) {
                            realm.write {
                                realm.delete(friend)
                            }
                        }
                    }
                }
                >- flatMap { (ids: [String]) -> Observable<[String]> in
                    var batch = [[String]]()
                    var i = 0
                    while i < ids.count {
                        let end = min(i + 100, ids.count)
                        batch.append(Array(ids[i..<end]))
                        i += 100
                    }
                    return from(batch)
                }
                >- flatMap { (ids: [String]) -> Observable<AnyObject> in
                    println(ids)
                    return requestStream(config)(.UsersLookup, [.UserIds(ids), .IncludeEntities(false)])
                }
                >- map { (data: AnyObject) -> [UserApiData] in
                    let users: [UserApiData]? = decode(data)
                    println(users)
                    return users!
                }
                >- reduce([UserApiData]()) { $0 + $1 }
                >- subscribe(
                    next: {
                        println("next \($0.map { $0.id })")
                    },
                    error: {
                        println("error \($0)")
                    },
                    completed: { sendNext(observer, ()) })

            return AnonymousDisposable {}
        }
    }
    >- publish
}
