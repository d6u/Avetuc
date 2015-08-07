import Foundation
import RxSwift

class River {
    static let instance = River()

    init() {
        let requestTokenStream = createRequestTokenStream(self.action_addAccountFromWeb)
        let createAccountStream = createCreateAccountStream(
            requestTokenStream,
            self.action_handleOauthCallback,
            self.stream_addAccountError)

        self.stream_account = merge(returnElements(createAccountStream, defaultAccount())) >- replay(1)
        self.stream_account.connect()

        let updateAccountStream = createUpdateAccountStream(self.action_updateAccount)

        self.stream_friends = createFriendsStream(self.stream_account, updateAccountStream)

        updateAccountStream.connect()

        defaultAccount()
            >- subscribeNext {
                if let account = $0 {
                    sendNext(self.action_updateAccount, account)
                }
            }
    }

    let action_addAccountFromWeb = PublishSubject<Void>()
    let action_handleOauthCallback = PublishSubject<NSURL>()
    let action_updateAccount = PublishSubject<Account>()

    let stream_addAccountError = PublishSubject<NSError>()
    let stream_account: ConnectableObservableType<Account?>
    let stream_friends: Observable<[User]>
}
