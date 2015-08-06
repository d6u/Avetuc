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

        self.stream_friends = self.stream_account
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
            >- variable

        let s = createUpdateAccountStream(self.action_updateAccount)
        s.connect()

        self.stream_account
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
