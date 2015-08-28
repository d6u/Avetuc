import Foundation
import RealmSwift

class HashtagEntity: Object {
    dynamic var text: String = ""
    dynamic var indices: EntityIndices?
}
