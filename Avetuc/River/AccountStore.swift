import Foundation
import RxSwift
import RealmSwift

class AccountStore {

    private weak var river: River!
    private var output: ConnectableObservableType<Account?>!

    func active(river: River) {
        self.river = river

        self.output = river.action_addAccount
            >- map { account -> Account? in
                account
            }
            >- startWith(Realm().objects(Account).first)
            >- replay(1)

        self.output.connect()
    }

    func get() -> Observable<Account?> {
        return self.output
    }
}
