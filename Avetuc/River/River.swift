import Foundation
import RxSwift

class River {

    static let instance = River()

    let action_addAccount = PublishSubject<Account>()
    let action_requestUpdateAccount = PublishSubject<String?>()
    let action_updateTweetReadState = PublishSubject<(id: Int64, isRead: Bool)>()

    let getUpdateAccountObservable: () -> Observable<()>
    let getAccountObservable: () -> Observable<Account?>
    let getFriendsObservable: Account -> Observable<[User]>
    let getTweetsObservable: User -> Observable<[TweetCellData]>

    init() {
        let accountStore = AccountStore()
        self.getAccountObservable = accountStore.get

        let updateAccountStore = UpdateAccountStore()
        self.getUpdateAccountObservable = updateAccountStore.get

        let friendsStore = FriendsStore()
        self.getFriendsObservable = friendsStore.get

        let tweetsStore = TweetsStore()
        self.getTweetsObservable = tweetsStore.get

        // Active order matters
        // TODO: - Auto active with dependency injection

        accountStore.active(self)
        updateAccountStore.active(self)
        friendsStore.active(self)
        tweetsStore.active(self)
    }
}
