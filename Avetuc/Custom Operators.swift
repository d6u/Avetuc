import Foundation
import RxSwift

func flattern<R>(source: Observable<Observable<R>>) -> Observable<R> {
    return source >- flatMap { (stream: Observable<R>) in
        return stream
    }
}

func combineModifier<E, M>
    (modifierSource: Observable<M>, modify: (E, M) -> E)
    (source: Observable<E>)
    -> Observable<E>
{
    return create { o in

        var cache: E?

        let disposable1 = source
            >- subscribe { e in
                switch e {
                case .Next(let box):
                    cache = box.value
                    sendNext(o, box.value)
                default:
                    send(o, e)
                }
        }

        let disposable2 = modifierSource
            >- subscribe { e in
                switch e {
                case .Next(let box):
                    if let c = cache {
                        cache = modify(c, box.value)
                        sendNext(o, cache!)
                    }
                case .Error(let err):
                    sendError(o, err)
                case .Completed:
                    sendCompleted(o)
                }
        }

        return AnonymousDisposable {
            disposable1.dispose()
            disposable2.dispose()
            cache = nil
        }
    }
}
