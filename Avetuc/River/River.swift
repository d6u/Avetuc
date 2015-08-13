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
    private let observer_tweetReadStateChange:  ConnectableObservableType<[(tweet: Tweet, user: User)]>
    private let observer_updateAccount: ConnectableObservableType<()>

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

    var observable_tweetReadStateChange: Observable<[(tweet: Tweet, user: User)]> {
        return self.observer_tweetReadStateChange
    }

    var observable_updateAccountStart: Observable<String?> {
        return self.action_updateAccount >- asObservable
    }

    var observable_updateAccountFinish: Observable<()> {
        return self.observer_updateAccount >- asObservable
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


        self.observer_updateAccount = self.action_updateAccount
            >- update
            >- publish


        self.observer_tweetReadStateChange = self.action_updateTweetReadState
            >- asObservable
            >- updateTweetReadState
            >- publish


        let stream_friends = combineLatest(
            self.observer_account,
            self.observer_updateAccount >- startWith())
            {
                (account, ()) in account
            }
            >- loadFriends(self.observer_tweetReadStateChange)
            >- publish

        stream_friends.subscribe(self.observer_friends)
        stream_friends.connect()


        self.observer_statuses = combineLatest(
            self.action_selectFriend,
            self.observer_updateAccount >- startWith()) {
                (id, ()) in id
            }
            >- loadStatuses(self.observer_tweetReadStateChange >- asObservable)


        self.observer_tweetReadStateChange.connect()
        self.observer_updateAccount.connect()

//        sendNext(self.action_updateAccount, nil)
    }
}
