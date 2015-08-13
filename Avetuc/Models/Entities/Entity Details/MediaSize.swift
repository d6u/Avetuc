import Foundation
import RealmSwift

class MediaSize: Object {
    dynamic var type: String = ""
    dynamic var w: Int64 = -1
    dynamic var h: Int64 = -1
    dynamic var resize: String = ""
}
