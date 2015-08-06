import Foundation
import RxSwift
import RealmSwift
import LarryBird
import Argo

class River {
    static let instance = River()

    init() {
        let requestTokenStream = createRequestTokenStream(self.action_addAccountFromWeb)
        let createAccountStream = createCreateAccountStream(
            requestTokenStream,
            self.action_handleOauthCallback,
            self.stream_addAccountError)

        self.stream_account = merge(returnElements(createAccountStream, defaultAccount())) >- replay(1)
        self.stream_account.connect()

        self.stream_friends = self.stream_account
            >- filter { account in
                return account != nil
            }
            >- map { account -> Account in
                return account!
            }
            >- flatMap { (account: Account) -> Observable<[User]> in
                let model = Realm().objects(AccountModel).filter("user_id = %@", account.user_id).first!
                let friends = Array(model.friends).map { $0.toData() }
                return just(friends)
            }
            >- variable

//        self.action_update
//            >- flatMap { () -> Observable<Account> in
//                let accounts = Array(Realm().objects(AccountModel)).map { $0.toData() }
//                return from(accounts)
//            }
//            >- flatMap { (account: Account) -> Observable<Void> in
//                requestFriendIdsStream(account)
//                    >- doOnNext { ids in
//                        let realm = Realm()
//                        let accountModel = realm.objects(AccountModel).filter("user_id = %@", account.user_id).first!
//                        for friend in accountModel.friends {
//                            if !contains(ids, friend.id_str) {
//                                realm.write {
//                                    realm.delete(friend)
//                                }
//                            }
//                        }
//                    }
//                    >- flatMap { (ids: [String]) -> Observable<[String]> in
//                        var batch = [[String]]()
//                        var i = 0
//
//                        while i < ids.count {
//                            let end = min(i + 100, ids.count)
//                            batch.append(Array(ids[i..<end]))
//                            i += 100
//                        }
//
//                        return from(batch)
//                    }
//                    >- flatMap { (ids: [String]) -> Observable<UserApiData> in
//
//                    }
//
//                return empty()
//            }
    }

    let action_addAccountFromWeb = PublishSubject<Void>()
    let action_handleOauthCallback = PublishSubject<NSURL>()
    let action_update = Variable<Void>()

    let stream_addAccountError = PublishSubject<NSError>()
    let stream_account: ConnectableObservableType<Account?>
    let stream_friends: Observable<[User]>
}
