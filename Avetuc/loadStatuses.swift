import Foundation
import RxSwift
import RealmSwift

struct TweetCellData {
    let original_tweet: Tweet
    let parsed_tweet: ParsedTweet
    let retweeted_user: User?
}

func loadStatuses(action: Observable<Int64>) -> Observable<[TweetCellData]> {
    return action
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
        >- debug("loadStatuses")
//        >- combineModifier(updateTweetReadStateStream) {
//            (data: [TweetCellData], modifierData: (Tweet, User)) -> [TweetCellData] in
//
//            var updatedData = data
//            let (tweet, user) = modifierData
//
//            for (i, d) in enumerate(data) {
//                if d.original_tweet.id == tweet.id {
//                    updatedData[i] = TweetCellData(
//                        original_tweet: tweet,
//                        parsed_tweet: d.parsed_tweet,
//                        retweeted_user: d.retweeted_user)
//                }
//            }
//            
//            return updatedData
//        }
}
