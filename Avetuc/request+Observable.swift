import Foundation
import LarryBird
import RxSwift

typealias JSONDict = [String: AnyObject]

func requestStream(config: Config)(_ endpoint: Endpoint, _ params: [Param]) -> Observable<JSONDict> {
    return create { (o: ObserverOf<JSONDict>) in
        request(config)(endpoint, params) { err, data in
            if let data = data {
                sendNext(o, data)
                sendCompleted(o)
            } else if let err = err {
                sendError(o, err)
            } else {
                sendError(o, UnknownError)
            }
        }

        return AnonymousDisposable {}
    }
}

func requestAccessTokenStream(config: Config)(_ oauthReturnUrl: NSURL) -> Observable<JSONDict> {
    return create { (o: ObserverOf<JSONDict>) in
        requestAccessToken(config)(oauthReturnUrl) { err, data in
            if let data = data {
                sendNext(o, data)
                sendCompleted(o)
            } else if let err = err {
                sendError(o, err)
            } else {
                sendError(o, UnknownError)
            }
        }

        return AnonymousDisposable {}
    }
}
