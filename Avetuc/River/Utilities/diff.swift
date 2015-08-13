import Foundation

struct DiffItem<T> {
    let element: T
    let index: Int
}

struct MovedItem<T> {
    let element: T
    let newIndex: Int
    let oldIndex: Int
}

enum DiffResult<T> {
    case Initial([T])
    case Differences(insert: [DiffItem<T>], remove: [DiffItem<T>], update: [DiffItem<T>], move: [MovedItem<T>])
}

func diff<E: Equatable>(hasUpdate: (E, E) -> Bool)(pre: [E]?, new: [E]) -> DiffResult<E> {
    var insert = [DiffItem<E>]()
    var remove = [DiffItem<E>]()
    var update = [DiffItem<E>]()
    var move = [MovedItem<E>]()

    if let pre = pre {
        if pre.count == 0 {
            return .Initial(new)
        }

        for (i, el) in enumerate(new) {
            if !contains(pre, el) {
                insert.append(DiffItem(element: el, index: i))
            }
            else if i < pre.count && el == pre[i] && hasUpdate(el, pre[i]) {
                update.append(DiffItem(element: el, index: i))
            }
            else if let oldIndex = find(pre, el) where oldIndex != i {
                move.append(MovedItem(element: el, newIndex: i, oldIndex: oldIndex))
            }
        }

        for (i, el) in enumerate(pre) {
            if !contains(new, el) {
                remove.append(DiffItem(element: el, index: i))
            }
        }

        return .Differences(insert: insert, remove: remove, update: update, move: move)
    }
    else {
        return .Initial(new)
    }
}
