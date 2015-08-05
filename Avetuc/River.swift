import Foundation
import RxSwift
import RealmSwift
import LarryBird
import Argo

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
    }

    let action_addAccountFromWeb = PublishSubject<Void>()
    let action_handleOauthCallback = PublishSubject<NSURL>()

    let stream_addAccountError = PublishSubject<NSError>()
    let stream_account: ConnectableObservableType<Account?>
}
