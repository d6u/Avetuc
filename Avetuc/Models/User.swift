import Foundation
import RealmSwift

class User: Object {

    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""
    dynamic var name: String = ""
    dynamic var screen_name: String = ""
    dynamic var location: String = ""
    dynamic var t_description: String = "" // Cannot override builtin `description`, TODO: handle this
    dynamic var url: String = ""
    // dynamic var entities: UserEntities = // TODO
    dynamic var protected: Bool = false
    dynamic var followers_count: Int64 = -1
    dynamic var friends_count: Int64 = -1
    dynamic var listed_count: Int64 = -1
    dynamic var created_at: String = ""
    dynamic var favourites_count: Int64 = -1
    dynamic var utc_offset: Int64 = -1
    dynamic var time_zone: String = ""
    // dynamic var geo_enabled: Bool =
    dynamic var verified: Bool = false
    dynamic var statuses_count: Int64 = -1
    dynamic var lang: String = ""
    // dynamic var contributors_enabled: Bool =
    // dynamic var is_translator: Bool =
    // dynamic var is_translation_enabled: Bool =
    dynamic var profile_background_color: String = ""
    dynamic var profile_background_image_url: String = ""
    dynamic var profile_background_image_url_https: String = ""
    // dynamic var profile_background_tile: Bool =
    dynamic var profile_image_url: String = ""
    dynamic var profile_image_url_https: String = ""
    dynamic var profile_link_color: String = ""
    // dynamic var profile_sidebar_border_color: String =
    // dynamic var profile_sidebar_fill_color: String =
    dynamic var profile_text_color: String = ""
    dynamic var profile_use_background_image: Bool = false
    dynamic var default_profile: Bool = false
    dynamic var default_profile_image: Bool = false
    dynamic var following: Bool = false
    dynamic var follow_request_sent: Bool = false
    dynamic var notifications: Bool = false
    dynamic var profile_banner_url: String = ""

    // MARK: - Custom
    dynamic var unread_status_count: Int64 = 0

    override static func primaryKey() -> String? {
        return "id"
    }

}
