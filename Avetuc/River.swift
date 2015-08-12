import Foundation
import RxSwift

class River {

    static let instance = River()

    let action_addAccountFromWeb = PublishSubject<()>()
    let action_handleOauthCallback = PublishSubject<NSURL>()
    let action_updateAccount = PublishSubject<String?>()
    let action_selectFriend = PublishSubject<Int64>()
    let action_updateTweetReadState = PublishSubject<(id: Int64, isRead: Bool)>()

    private let observer_addAccountError = PublishSubject<NSError>()
    private let observer_account = ReplaySubject<Account?>(bufferSize: 1)
    private let observer_friends = ReplaySubject<([User], DiffResult<User>)>(bufferSize: 1)
    private let observer_statuses: Observable<([TweetCellData], DiffResult<TweetCellData>)>

    var observable_addAccountError: Observable<NSError> {
        return self.observer_addAccountError >- asObservable
    }

    var observable_account: Observable<Account?> {
        return self.observer_account >- asObservable
    }

    var observable_friends: Observable<([User], DiffResult<User>)> {
        return self.observer_friends >- asObservable
    }

    var observable_statuses: Observable<([TweetCellData], DiffResult<TweetCellData>)> {
        return self.observer_statuses >- asObservable
    }

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


        let stream_updateTweetReadState = self.action_updateTweetReadState
            >- asObservable
            >- updateTweetReadState
            >- publish


        let stream_friends = combineLatest(
            self.observer_account,
            stream_updateAccount >- startWith())
            {
                (account, ()) in account
            }
            >- loadFriends(stream_updateTweetReadState)
            >- publish

        stream_friends.subscribe(self.observer_friends)
        stream_friends.connect()


        self.observer_statuses = combineLatest(
            self.action_selectFriend,
            stream_updateAccount >- startWith()) {
                (id, ()) in id
            }
            >- loadStatuses(stream_updateTweetReadState >- asObservable)


        stream_updateTweetReadState.connect()
        stream_updateAccount.connect()

//        sendNext(self.action_updateAccount, nil)
    }
}
