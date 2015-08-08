import Foundation
import RxSwift
import RealmSwift

func createUpdateTweetReadStateStream(action_updateTweetReadState: PublishSubject<(id: Int64, isRead: Bool)>)
    -> Observable<(tweet: Tweet, user: User)>
{
    return action_updateTweetReadState
        >- map { (id, isRead) -> (Tweet, User) in
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
}
