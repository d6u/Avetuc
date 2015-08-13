import Foundation
import LarryBird
import RxSwift

typealias WebAuthUrlResponse = (data: [String: String], url: NSURL)

func requestStream(config: Config)(_ endpoint: Endpoint, _ params: [Param]) -> Observable<AnyObject> {
    return create { (o: ObserverOf<AnyObject>) in
        request(config)(endpoint, params) { err, data in
            if let data: AnyObject = data {
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

func requestWebAuthUrlStream(config: Config)(_ callbackUrl: String) -> Observable<WebAuthUrlResponse> {
    return create { (o: ObserverOf<WebAuthUrlResponse>) in

        requestWebAuthUrl(config)(callbackUrl) { err, res in
            if let res = res {
                sendNext(o, res)
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

func requestAccessTokenStream(config: Config)(_ oauthReturnUrl: NSURL) -> Observable<AnyObject> {
    return create { (o: ObserverOf<AnyObject>) in
        requestAccessToken(config)(oauthReturnUrl) { err, data in
            if let data: AnyObject = data {
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
