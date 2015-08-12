import Foundation
import RealmSwift

class Account: Object {

    dynamic var user_id: String = ""
    dynamic var screen_name: String = ""
    dynamic var oauth_token: String = ""
    dynamic var oauth_token_secret: String = ""

    // MARK: - Custom
    dynamic var last_fetch_since_id: Int64 = -1

    dynamic var profile: User?

    let home_timeline = List<Tweet>()

    override static func primaryKey() -> String? {
        return "user_id"
    }

}
