import Foundation
import RxSwift
import RealmSwift

class UpdateTweetReadStateStore {

    private weak var river: River!
    private var output: ConnectableObservableType<Tweet>!

    func active(river: River) {
        self.river = river

        self.output = river.action_updateTweetReadState
            >- map { tweet, isRead -> Tweet in
                if tweet.is_read != isRead {
                    Realm().write {
                        tweet.is_read = isRead
                        tweet.user!.unread_status_count += isRead ? -1 : 1
                    }
                }

                return tweet
            }
            >- publish

        self.output.connect()
    }

    func get() -> Observable<Tweet> {
        return self.output
    }
}
