import Foundation
import RxSwift
import LarryBird
import Argo
import RealmSwift

func createUpdateFriendsStream(account: Account) -> Observable<[User]> {

    let config = configFromAccount(account)
    let realm = Realm()
    let accountModel = realm.objects(AccountModel).filter("user_id = %@", account.user_id).first!
    let requestEndpoint = requestStream(config)

    return requestEndpoint(.FriendsIds, [.UserId(account.user_id), .Count(5000), .StringifyIds(true)])
        >- map { data -> [String] in
            let friendsIds: FriendsIdsData? = decode(data)
            return friendsIds!.ids
        }
        >- doOnNext { ids in
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
            requestEndpoint(.UsersLookup, [.UserIds(ids), .IncludeEntities(false)]) >- catch { err in empty() }
        }
        >- map { (data: AnyObject) -> [UserApiData] in
            let users: [UserApiData]? = decode(data)
            return users!
        }
        >- map { (data: [UserApiData]) -> [User] in

            var users = [UserModel]()

            realm.write {
                for d in data {
                    if let user = accountModel.friends.filter("id = %ld", d.id).first {
                        user.fromApiData(d, update: true)
                        users.append(user)
                    } else {
                        let user = UserModel().fromApiData(d)
                        accountModel.friends.append(user)
                        users.append(user)
                    }
                }

                realm.add(users, update: true)
            }

            return users.map { $0.toData() }
        }
        >- reduce([User]()) { $0 + $1 }
}
