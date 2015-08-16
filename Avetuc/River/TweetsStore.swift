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
                tweets.map { tweet in
                    let text: NSAttributedString

                    if let retweeted_status = tweet.retweeted_status {
                        text = parseTweetText(retweeted_status)
                    } else {
                        text = parseTweetText(tweet)
                    }

                    return TweetCellData(tweet: tweet, text: text)
                }
            }
    }
}
