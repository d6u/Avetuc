import Foundation
import RxSwift
import LarryBird

func createRequestTokenStream(action_addAccountFromWeb: PublishSubject<Void>) -> Observable<Config> {
    return action_addAccountFromWeb
        >- flatMap { () -> Observable<WebAuthUrlResponse> in
            return requestWebAuthUrlStream(defaultConfig())(TWITTER_OAUTH_CALLBACK)
        }
        >- doOnNext { (data: [String: String], url: NSURL) in
            UIApplication.sharedApplication().openURL(url)
        }
        >- map { res in configFromRequestTokenData(res.data) }
}
