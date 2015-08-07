import Foundation
import RxSwift
import RealmSwift

func createFriendsStream(stream_account: Observable<Account?>, updateAccountStream: Observable<()>) -> Observable<[User]> {
    return combineLatest(stream_account, updateAccountStream >- startWith()) {
        (account: Account?, ()) -> Account? in
        return account
        }
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
        >- map { (friends: [User]) -> [User] in
            multiSort(friends, [
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
        >- variable
}
