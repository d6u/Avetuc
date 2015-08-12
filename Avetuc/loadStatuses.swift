import Foundation
import RxSwift
import RealmSwift

struct TweetCellData: Equatable {
    let tweet: Tweet
    let text: NSAttributedString
}

func ==(lhs: TweetCellData, rhs: TweetCellData) -> Bool {
    return lhs.tweet.id == rhs.tweet.id
}

func loadStatuses
    (tweetUpdateStream: Observable<[(tweet: Tweet, user: User)]>)
    (action: Observable<Int64>)
    -> Observable<([TweetCellData], DiffResult<TweetCellData>)>
{
    let diffTweetCellData = diff { (a: TweetCellData, b: TweetCellData) in
        a.tweet.is_read != b.tweet.is_read
    }

    return action
        >- observeOn(CommonScheduler.instance)
        >- map { (user_id: Int64) -> [Tweet] in
            let realm = Realm()
            let user = realm.objects(User).filter("id = %ld", user_id).first!
            let tweets = realm.objects(Tweet.self).filter("user = $@", user)
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
        >- combineModifier(tweetUpdateStream) { cellsData, changes in
            var updatedCellData = cellsData

            for (i, data) in enumerate(cellsData) {
                for change in changes {
                    let (tweet, _) = change

                    if data.tweet.id == tweet.id {
                        updatedCellData[i] = TweetCellData(tweet: tweet, text: data.text)
                    }
                }
            }

            return updatedCellData
        }
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
        >- cachePrevious
        >- map { pre, new in
            (new, diffTweetCellData(pre: pre, new: new))
        }
        >- observeOn(MainScheduler.sharedInstance)
}
