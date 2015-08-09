import Foundation

struct DiffItem<E> {
    let element: E
    let index: Int
}

struct MovedDiffItem<E> {
    let element: E
    let previousIndex: Int
    let newIndex: Int
}

struct DiffResult<E> {
    let added: [DiffItem<E>]
    let removed: [DiffItem<E>]
    let updated: [DiffItem<E>]
    let moved: [MovedDiffItem<E>]
}

func diff<E: Equatable>(hasUpdate: (E, E) -> Bool)(pre: [E]?, new: [E]) -> DiffResult<E> {
    var add = [DiffItem<E>]()
    var rem = [DiffItem<E>]()
    var upd = [DiffItem<E>]()
    var mov = [MovedDiffItem<E>]()

    if let pre = pre {
        for (i, el) in enumerate(new) {
            if !contains(pre, el) {
                add.append(DiffItem(element: el, index: i))
            }
            else if i < pre.count && el == pre[i] && hasUpdate(el, pre[i]) {
                upd.append(DiffItem(element: el, index: i))
            }
            else if let preIndex = find(pre, el) where preIndex != i {
                mov.append(MovedDiffItem(element: el, previousIndex: preIndex, newIndex: i))
            }
        }

        for (i, el) in enumerate(pre) {
            if !contains(new, el) {
                rem.append(DiffItem(element: el, index: i))
            }
        }
    }
    else {
        for (i, el) in enumerate(new) {
            add.append(DiffItem(element: el, index: i))
        }
    }

    return DiffResult(added: add, removed: rem, updated: upd, moved: mov)
}
