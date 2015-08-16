import Foundation
import RxSwift
import RealmSwift

class FriendsStore {

    private weak var river: River!

    func active(river: River) {
        self.river = river
    }

    func get(account: Account) -> Observable<[User]> {

        return self.river.getUpdateAccountObservable()
            >- startWith()
            >- map { () -> [User] in
                var friends = Set<User>()
                for tweet in account.home_timeline {
                    friends.insert(tweet.user)
                }
                return Array(friends)
            }
            >- filter { $0.count > 0 }
//            >- combineModifier(tweetUpdateStream) { friends, changes in
//                var updatedFriends = friends
//
//                for (i, friend) in enumerate(friends) {
//                    for change in changes {
//                        let (_, user) = change
//
//                        if friend == user {
//                            updatedFriends[i] = user
//                        }
//                    }
//                }
//
//                return updatedFriends
//            }
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
    }
}
