import Foundation
import RxSwift
import LarryBird
import Argo
import RealmSwift

func update(action: PublishSubject<String?>) -> Observable<()> {
    return action
        >- flatMap { (id: String?) -> Observable<Account> in
            let realm = Realm()
            if let id = id {
                let accountModel = realm.objects(AccountModel).filter("user_id = %@", id).first!
                return just(accountModel.toData())
            } else {
                return from(Array(realm.objects(AccountModel)).map { $0.toData() })
            }
        }
        >- flatMap { (account: Account) -> Observable<()> in
            createUpdateAccountStream(account) >- catch { err in empty() }
        }
        >- debug("update account stream")
}
