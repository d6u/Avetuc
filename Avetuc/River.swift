import Foundation
import RxSwift

class River {

    static let instance = River()

    let action_addAccountFromWeb = PublishSubject<()>()
    let action_handleOauthCallback = PublishSubject<NSURL>()
    let action_updateAccount = PublishSubject<String?>()
    let action_selectFriend = PublishSubject<Int64>()
    let action_updateTweetReadState = PublishSubject<(id: Int64, isRead: Bool)>()

    let observer_addAccountError = PublishSubject<NSError>()
    let observer_account = ReplaySubject<Account?>(bufferSize: 1)
    let observer_friends = ReplaySubject<[User]>(bufferSize: 1)
    let observer_statuses = ReplaySubject<[TweetCellData]>(bufferSize: 1)

    init() {
        let stream_addAccountFromWeb = self.action_addAccountFromWeb
            >- asObservable
            >- addAccountFromWeb(self.observer_addAccountError, self.action_handleOauthCallback)
            >- map { account -> Account? in
                account
            }
            >- startWith(defaultAccount())
            >- publish

        stream_addAccountFromWeb.subscribe(self.observer_account)
        stream_addAccountFromWeb.connect()


        let stream_updateAccount = self.action_updateAccount
            >- update
            >- publish


        let stream_friends = combineLatest(
            self.observer_account,
            stream_updateAccount >- startWith())
            {
                (account, ()) in account
            }
            >- loadFriends
            >- publish

        stream_friends.subscribe(self.observer_friends)
        stream_friends.connect()


        let stream_statuses = combineLatest(
            self.action_selectFriend,
            stream_updateAccount >- startWith())
            {
                (id, ()) in id
            }
            >- loadStatuses
            >- publish

        stream_statuses.subscribe(self.observer_statuses)
        stream_statuses.connect()


        stream_updateAccount.connect()
    }
}
