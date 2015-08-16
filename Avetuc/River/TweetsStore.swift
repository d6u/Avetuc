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
                let tweets = Realm().objects(Tweet.self).filter("user = %@", user)
                return Array(tweets)
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
//            >- combineModifier(tweetUpdateStream) { cellsData, changes in
//                var updatedCellData = cellsData
//
//                for (i, data) in enumerate(cellsData) {
//                    for change in changes {
//                        let (tweet, _) = change
//
//                        if data.tweet == tweet {
//                            updatedCellData[i] = TweetCellData(tweet: tweet, text: data.text)
//                        }
//                    }
//                }
//
//                return updatedCellData
//            }
            >- map {
                multiSort($0, [
                    {
                        if $0.tweet.id > $1.tweet.id {
                            return .LeftFirst
                        } else if $0.tweet.id < $1.tweet.id {
                            return .RightFirst
                        } else {
                            return .Same
                        }
                    }
                ])
            }
    }
}
