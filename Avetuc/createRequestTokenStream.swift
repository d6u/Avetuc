import Foundation
import RxSwift
import LarryBird

func createRequestTokenStream(action_addAccountFromWeb: PublishSubject<Void>) -> Observable<Config> {
    return action_addAccountFromWeb
        >- flatMap { () -> Observable<NSURL> in
            return requestWebAuthUrlStream(defaultConfig())(TWITTER_OAUTH_CALLBACK)
        }
        >- doOnNext { url in
            UIApplication.sharedApplication().openURL(url)
        }
        >- map(configFromRequestTokenData)
}
