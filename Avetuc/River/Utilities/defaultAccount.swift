import Foundation
import RealmSwift

func defaultAccount() -> Account? {
    return Realm().objects(Account).first
}
