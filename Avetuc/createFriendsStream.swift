import Foundation
import RxSwift
import RealmSwift

func createFriendsStream(
    stream_account: Observable<Account?>,
    updateAccountStream: Observable<()>,
    updateTweetReadStateStream: Observable<(tweet: Tweet, user: User)>)
    -> Observable<[User]>
{
    return combineLatest(stream_account, updateAccountStream >- startWith()) {
        (account: Account?, ()) -> Account? in
        println("friends stream \(account)")
        return account
        }
        >- filter { account in
            return account != nil
        }
        >- map { account -> Account in
            return account!
        }
        >- map { (account: Account) -> [User] in
            let model = Realm().objects(AccountModel).filter("user_id = %@", account.user_id).first!
            return Array(model.friends).map { $0.toData() }
        }
        >- combineModifier(updateTweetReadStateStream) { (friends: [User], data: (Tweet, User)) -> [User] in

            var updatedFriends = friends
            let (tweet, user) = data

            for (index, friend) in enumerate(friends) {
                if friend.id == user.id {
                    updatedFriends[index] = user
                    break
                }
            }

            return updatedFriends
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
