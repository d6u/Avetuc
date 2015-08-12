import Foundation
import RxSwift
import RealmSwift

func updateTweetReadState(action: Observable<(id: Int64, isRead: Bool)>) -> Observable<[(tweet: Tweet, user: User)]> {
    return action
        >- buffer(0.5)
        >- map { data -> [(tweet: Tweet, user: User)] in
            let realm = Realm()
            var results = Array<(tweet: Tweet, user: User)>()

            for d in data {
                let (id, isRead) = d
                let tweet = realm.objects(TweetModel).filter("id == %ld", id).first!

                if tweet.is_read != isRead {
                    realm.write {
                        tweet.is_read = isRead
                        tweet.user!.unread_status_count += isRead ? -1 : 1
                    }

                    results.append((tweet: tweet.toData(), user: tweet.user!.toData()))
                }
            }

            return results
        }
}
