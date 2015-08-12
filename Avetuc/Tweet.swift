import Foundation
import RealmSwift

class Tweet: Object {

    dynamic var created_at: String = ""
    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""
    dynamic var text: String = ""
    dynamic var source: String = ""
    dynamic var truncated: Bool = false
    dynamic var in_reply_to_status_id: Int64 = -1
    dynamic var in_reply_to_status_id_str: String = ""
    dynamic var in_reply_to_user_id: Int64 = -1
    dynamic var in_reply_to_user_id_str: String = ""
    dynamic var in_reply_to_screen_name: String = ""
    // dynamic var geo: Coordinates? = ""
    // dynamic var coordinates: Coordinates? = ""
    // dynamic var place: Place? = ""
    dynamic var retweet_count: Int64 = -1
    dynamic var favorite_count: Int64 = -1
    dynamic var favorited: Bool = false
    dynamic var retweeted: Bool = false
    dynamic var possibly_sensitive: Bool = false
    dynamic var possibly_sensitive_appealable: Bool = false
    dynamic var lang: String = ""

    // MARK: - Custom
    dynamic var is_read: Bool = false

    dynamic var user = User()
    dynamic var retweeted_status: Tweet?
    dynamic var entities = Entities()
    dynamic var extended_entities = ExtendedEntities()

    override static func primaryKey() -> String? {
        return "id"
    }

    dynamic var parsedText = NSAttributedString()

    override static func ignoredProperties() -> [String] {
        return ["parsedText"]
    }

}
