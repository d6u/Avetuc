import Foundation

func removeNull(data: AnyObject) -> AnyObject {
    switch data {
    case let d as [String: AnyObject]:
        var r = [String: AnyObject]()
        for (key, value) in d {
            switch value {
            case let nested as [String: AnyObject]:
                r[key] = removeNull(value)
            case let value as NSNull:
                break
            default:
                r[key] = value
            }
        }
        return r
    case let arr as [AnyObject]:
        return arr.map { removeNull($0) }
    default:
        return data
    }
}
