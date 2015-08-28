import Foundation
import RealmSwift

class UrlEntity: Object {
    dynamic var url: String = ""
    dynamic var expanded_url: String = ""
    dynamic var display_url: String = ""
    dynamic var indices: EntityIndices?
}
