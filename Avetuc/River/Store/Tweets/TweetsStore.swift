import Foundation
import RxSwift
import RealmSwift

class TweetsStore {

    private weak var river: River!

    func active(river: River) {
        self.river = river
    }

    func get(user: User) -> Observable<[TweetCellData]> {

        return self.river.getUpdateAccountObservable()
            >- startWith()
            >- map { () -> [Tweet] in
                let tweets = Realm().objects(Tweet.self).filter("user = %@", user).sorted("id", ascending: false)
                return LoadedObjects.instance.getLoadedTweets(Array(tweets))
            }
            >- map { (tweets: [Tweet]) -> [TweetCellData] in
                tweets.map { TweetCellData(tweet: $0, text: nil) }
            }
    }
}
