import Foundation
import RealmSwift

class Entities: Object {
    let hashtags = List<HashtagEntity>()
    let user_mentions = List<UserMentionEntity>()
    let urls = List<UrlEntity>()
    let media = List<MediaEntity>()
}
