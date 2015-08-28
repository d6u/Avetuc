import Foundation
import RealmSwift

class UserMentionEntity: Object {
    dynamic var screen_name: String = ""
    dynamic var name: String = ""
    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""

    dynamic var indices: EntityIndices?
}
