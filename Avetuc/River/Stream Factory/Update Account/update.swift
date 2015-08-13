import Foundation
import RxSwift
import RealmSwift

func update(action: PublishSubject<String?>) -> Observable<()> {
    return action
        >- flatMap { (id: String?) -> Observable<Account> in
            let realm = Realm()
            if let id = id, let account = realm.objects(Account).filter("user_id = %@", id).first {
                return just(account)
            } else {
                return from(Array(realm.objects(Account)))
            }
        }
        >- flatMap { (account: Account) -> Observable<()> in
            createUpdateAccountStream(account) >- catch { err in empty() }
        }
}
