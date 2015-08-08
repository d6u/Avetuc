import Foundation
import RxSwift
import RealmSwift

func createStatusesStream(action_selectFriend: PublishSubject<Int64>) -> Observable<[ParsedTweet]> {
    return action_selectFriend
        >- map { (user_id: Int64) -> [ParsedTweet] in
            let realm = Realm()
            let userModel = realm.objects(UserModel).filter("id = %ld", user_id).first!

            let tweets = Array(userModel.statuses).map { tweet -> TweetAndRetweet in
                if let retweeted_status = tweet.retweeted_status {
                    return TweetAndRetweet(
                        tweet: tweet.toData(),
                        retweetedStatus: retweeted_status.toData(),
                        retweetedStatusUser: retweeted_status.user!.toData())
                } else {
                    return TweetAndRetweet(tweet: tweet.toData(), retweetedStatus: nil, retweetedStatusUser: nil)
                }
            }

            return tweets.map { parseTweet($0) }
        }
}
