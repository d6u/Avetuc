import Foundation
import RealmSwift

class MediaEntity: Object {
    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""
    dynamic var media_url: String = ""
    dynamic var media_url_https: String = ""
    dynamic var url: String = ""
    dynamic var display_url: String = ""
    dynamic var expanded_url: String = ""
    dynamic var type: String = ""
    dynamic var source_status_id: Int64 = -1
    dynamic var source_status_id_str: String = ""
    dynamic var source_user_id: Int64 = -1
    dynamic var source_user_id_str: String = ""

    dynamic var indices = EntityIndices()
    dynamic var sizes = MediaSizes()
}
