import Foundation
import RxSwift
import RealmSwift

class UpdateAccountStore {

    private weak var river: River!
    private var output: ConnectableObservableType<()>!

    func active(river: River) {
        self.river = river

        self.output = river.action_requestUpdateAccount
            >- flatMap { (id: String?) -> Observable<Account> in
                let realm = Realm()
                if let id = id, let account = realm.objects(Account).filter("user_id = %@", id).first {
                    return just(account)
                }

                return from(Array(realm.objects(Account)))
            }
            >- flatMap { (account: Account) in
                createUpdateAccountStream(account) >- catch { err in empty() }
            }
            >- publish

        self.output.connect()
    }

    func get() -> Observable<()> {
        return self.output
    }
}
