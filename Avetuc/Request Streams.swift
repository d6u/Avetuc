import Foundation
import LarryBird
import RxSwift

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

func requestWebAuthUrlStream(config: Config)(_ callbackUrl: String) -> Observable<NSURL> {
    return create { (o: ObserverOf<NSURL>) in

        requestWebAuthUrl(config)(callbackUrl) { err, url in
            if let url = url {
                sendNext(o, url)
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
