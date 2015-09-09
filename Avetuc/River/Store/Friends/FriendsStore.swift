import Foundation
import RxSwift
import RealmSwift

class FriendsStore {

    private weak var river: River!

    func active(river: River) {
        self.river = river
    }

    func get(account: Account) -> Observable<[User]> {

        let s = self.river.getUpdateTweetReadStateObservable() >- buffer(0.5)

        return self.river.getUpdateAccountObservable()
            >- startWith()
            >- map { () -> [User] in
                var friends = Set<User>()
                for tweet in account.home_timeline {
                    friends.insert(tweet.user!)
                }
                return Array(friends)
            }
            >- filter { $0.count > 0 }
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
            >- combineModifier(s) { friends, changes in
                friends
            }
            >- map { original in
                var arr = original
                var i = 0
                var flag = true
                var tmp: User!
                var e1: User!
                var e2: User!

                while flag {
                    flag = false

                    for i = 0; i < arr.count - 1; i++ {
                        e1 = arr[i]
                        e2 = arr[i+1]
                        if e1.unread_status_count == e2.unread_status_count {
                            if e1.name > e2.name {
                                tmp = arr[i]
                                arr[i] = e2
                                arr[i+1] = tmp
                                flag = true
                            }
                        } else if e1.unread_status_count < e2.unread_status_count {
                            tmp = arr[i]
                            arr[i] = e2
                            arr[i+1] = tmp
                            flag = true
                        }
                    }
                }

                return arr
            }
    }
}
