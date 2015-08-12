import Foundation
import RxSwift
import RealmSwift

func updateTweetReadState(action: Observable<(id: Int64, isRead: Bool)>) -> Observable<[(tweet: Tweet, user: User)]> {
    return action
//        >- buffer(0.3)
//        >- observeOn(CommonScheduler.instance)
//        >- map { data -> [(tweet: Tweet, user: User)] in
//            let realm = Realm()
//            var changedTweets = [TweetModel]()
//
//            for d in data {
//                let (id, isRead) = d
//                let tweet = realm.objects(TweetModel).filter("id == %ld", id).first!
//
//                if tweet.is_read != isRead {
//                    realm.write {
//                        tweet.is_read = isRead
//                        tweet.user!.unread_status_count += isRead ? -1 : 1
//                    }
//
//                    changedTweets.append(tweet)
//                }
//            }
//
//            return changedTweets.map {
//                (tweet: $0.toData(), user: $0.user!.toData())
//            }
//        }
//        >- observeOn(MainScheduler.sharedInstance)
        >- map { (id, isRead) -> (tweet: Tweet, user: User) in
            let realm = Realm()

            let tweet = realm.objects(TweetModel).filter("id == %ld", id).first!

            if tweet.is_read != isRead {
                realm.write {
                    tweet.is_read = isRead
                    tweet.user!.unread_status_count += isRead ? -1 : 1
                }
            }

            return (tweet.toData(), tweet.user!.toData())
        }
        >- buffer(0.3)
}
