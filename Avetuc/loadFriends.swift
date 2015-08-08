import Foundation
import RxSwift
import RealmSwift

func loadFriends
    (accountObservable: Observable<Account?>)
    -> Observable<[User]>
{
    let stream1 = accountObservable
        >- filter { $0 != nil }
        >- map { $0! }
        >- map { account -> [User] in
            let model = Realm().objects(AccountModel).filter("user_id = %@", account.user_id).first!
            return Array(model.friends).map { $0.toData() }
        }
        >- map {
            multiSort($0, [
                {
                    if $0.unread_status_count > $1.unread_status_count {
                        return .LeftFirst
                    } else if $0.unread_status_count < $1.unread_status_count {
                        return .RightFirst
                    } else {
                        return .Same
                    }
                },
                {
                    if $0.name < $1.name {
                        return .LeftFirst
                    } else if $0.name > $1.name {
                        return .RightFirst
                    } else {
                        return .Same
                    }
                }
            ])
        }

    return stream1
}
