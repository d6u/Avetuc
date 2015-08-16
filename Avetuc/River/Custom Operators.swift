import Foundation
import RxSwift

func flattern<R>(source: Observable<Observable<R>>) -> Observable<R> {
    return source >- flatMap { (stream: Observable<R>) in stream }
}

func doOnError<E>(handler: ErrorType -> Void) -> Observable<E> -> Observable<E> {
    return { source in
        source
            >- `do` { event in
                switch event {
                case .Error(let err):
                    handler(err)
                default:
                    break
                }
            }
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

func cachePrevious<E>(source: Observable<E>) -> Observable<(E?, E)>
{
    return create { o in

        var cache: E?

        let disposable = source
            >- subscribe { e in
                switch e {
                case .Next(let box):
                    sendNext(o, (cache, box.value))
                    cache = box.value
                case .Error(let err):
                    sendError(o, err)
                case .Completed:
                    sendCompleted(o)
                }
            }

        return AnonymousDisposable {
            disposable.dispose()
            cache = nil
        }
    }
}

func buffer<E>(interval: Double)(source: Observable<E>) -> Observable<[E]> {
    return create { o in

        var timer: Timer?
        var cache: [E]?

        let disposable = source
            >- subscribe { e in
                switch e {
                case .Next(let box):
                    if timer == nil {
                        cache = [box.value]
                        timer = Timer(duration: interval) {
                            sendNext(o, cache!)
                            cache = nil
                            timer = nil
                        }
                    } else {
                        cache!.append(box.value)
                    }
                case .Error(let err):
                    sendError(o, err)
                case .Completed:
                    sendCompleted(o)
                }
        }

        return AnonymousDisposable {
            disposable.dispose()
            timer = nil
            cache = nil
        }
    }
}
