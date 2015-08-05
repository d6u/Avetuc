import Foundation
import RealmSwift
import RxSwift

func defaultAccount() -> Observable<Account?> {
    let account = Realm().objects(AccountModel).first?.toData()
    return just(account)
}
