import Foundation
import RxSwift

extension River {
    var observable_addAccountError: Observable<NSError> {
        return self.observer_addAccountError >- asObservable
    }

    var observable_account: Observable<Account?> {
        return self.observer_account >- asObservable
    }

    var observable_friends: Observable<[User]> {
        return self.observer_friends >- asObservable
    }

    var observable_statuses: Observable<[TweetCellData]> {
        return self.observer_statuses >- asObservable
    }
}
