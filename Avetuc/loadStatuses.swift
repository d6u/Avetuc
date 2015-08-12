import Foundation
import RxSwift
import RealmSwift

struct TweetCellData: Equatable {
    let original_tweet: Tweet
    let parsed_tweet: ParsedTweet
    let retweeted_user: User?
}

func ==(lhs: TweetCellData, rhs: TweetCellData) -> Bool {
    return lhs.original_tweet.id == rhs.original_tweet.id
}

func loadStatuses
    (tweetUpdateStream: Observable<[(tweet: Tweet, user: User)]>)
    (action: Observable<Int64>)
    -> Observable<([TweetCellData], DiffResult<TweetCellData>)>
{
    let diffTweetCellData = diff { (a: TweetCellData, b: TweetCellData) in
        a.original_tweet.is_read != b.original_tweet.is_read
    }

    return action
        >- observeOn(CommonScheduler.instance)
        >- map { (user_id: Int64) -> [TweetModel] in
            let realm = Realm()
            let userModel = realm.objects(UserModel).filter("id = %ld", user_id).first!
            return Array(userModel.statuses)
        }
        >- map { (models: [TweetModel]) -> [TweetCellData] in
            models.map { tweetModel in
                let tweet: Tweet
                let user: User?

                if let retweeted = tweetModel.retweeted_status {
                    tweet = retweeted.toData()
                    user = retweeted.user?.toData()
                } else {
                    tweet = tweetModel.toData()
                    user = nil
                }

                let parsedTweet = ParsedTweet(tweet: tweet, parsed_text: parseTweetText(tweet))
                return TweetCellData(original_tweet: tweetModel.toData(), parsed_tweet: parsedTweet, retweeted_user: user)
            }
        }
        >- combineModifier(tweetUpdateStream) { cellsData, changes in
            var updatedCellData = cellsData

            for (i, data) in enumerate(cellsData) {
                for change in changes {
                    let (tweet, _) = change

                    if data.original_tweet.id == tweet.id {
                        updatedCellData[i] = TweetCellData(
                            original_tweet: tweet,
                            parsed_tweet: data.parsed_tweet,
                            retweeted_user: data.retweeted_user)
                    }
                }
            }

            return updatedCellData
        }
        >- observeOn(CommonScheduler.instance)
        >- map {
            multiSort($0, [
                {
                    if $0.original_tweet.id > $1.original_tweet.id {
                        return .LeftFirst
                    } else if $0.original_tweet.id < $1.original_tweet.id {
                        return .RightFirst
                    } else {
                        return .Same
                    }
                }
            ])
        }
        >- cachePrevious
        >- observeOn(CommonScheduler.instance)
        >- map { pre, new in
            (new, diffTweetCellData(pre: pre, new: new))
        }
        >- observeOn(MainScheduler.sharedInstance)
}
