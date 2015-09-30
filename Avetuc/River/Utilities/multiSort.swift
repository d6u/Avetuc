import Foundation

enum SortResult {
    case LeftFirst
    case RightFirst
    case Same
}

func multiSort<T>(array: [T], sorter: [(T, T) -> SortResult]) -> [T]
{
    return array.sort({ (a, b) -> Bool in
        var r: SortResult = .LeftFirst

        for s in sorter {
            r = s(a, b)
            if r != .Same {
                break
            }
        }

        return r == .LeftFirst ? true : false
    })
}
