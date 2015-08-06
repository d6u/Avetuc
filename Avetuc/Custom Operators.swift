//
//  Custom Operators.swift
//  Avetuc
//
//  Created by Daiwei Lu on 8/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RxSwift

func flattern<R>(source: Observable<Observable<R>>) -> Observable<R> {
    return source >- flatMap { (stream: Observable<R>) in
        return stream
    }
}

func redirectError<R>(errorObserver: PublishSubject<NSError>) -> Observable<R> -> Observable<R> {
    return {
        $0
            >- `do` { event in
                switch event {
                case .Error(let err):
                    sendNext(errorObserver, err)
                default:
                    break
                }
            }
            >- retry
    }
}

func combineModifier<E, R>(other: Observable<R>, transform: (E, R) -> E) -> Observable<E> -> Observable<E> {
    return { source in
        let branch = combineLatest(source, other, transform)
        return merge(returnElements(source, branch))
    }
}
