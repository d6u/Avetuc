import Foundation
import RealmSwift

class MediaEntityExtended: Object {
    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""
    dynamic var media_url: String = ""
    dynamic var media_url_https: String = ""
    dynamic var url: String = ""
    dynamic var display_url: String = ""
    dynamic var expanded_url: String = ""
    dynamic var type: String = ""

    dynamic var indices = EntityIndices()
    dynamic var sizes = MediaSizes()
}
