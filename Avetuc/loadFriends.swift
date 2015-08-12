import Foundation
import RxSwift
import RealmSwift

func loadFriends
    (tweetUpdateStream: Observable<[(tweet: Tweet, user: User)]>)
    (accountObservable: Observable<Account?>)
    -> Observable<([User], DiffResult<User>)>
{
    let diffTweetCellData = diff { (a: User, b: User) in
        a.unread_status_count != b.unread_status_count
    }

    return accountObservable
        >- observeOn(CommonScheduler.instance)
        >- filter { $0 != nil }
        >- map { $0! }
        >- map { account -> [User] in
            let model = Realm().objects(AccountModel).filter("user_id = %@", account.user_id).first!
            return Array(model.friends).map { $0.toData() }
        }
        >- combineModifier(tweetUpdateStream) { friends, changes in
            var updatedFriends = friends

            for (i, friend) in enumerate(friends) {
                for change in changes {
                    let (_, user) = change

                    if friend.id == user.id {
                        updatedFriends[i] = user
                    }
                }
            }

            return updatedFriends
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
        >- cachePrevious
        >- map { pre, new in
            (new, diffTweetCellData(pre: pre, new: new))
        }
        >- observeOn(MainScheduler.sharedInstance)
}
