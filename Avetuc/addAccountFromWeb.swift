import Foundation
import RxSwift
import LarryBird
import RealmSwift
import Argo

func addAccountFromWeb
    (errorObserver: PublishSubject<NSError>, urlObserver: PublishSubject<NSURL>)
    (action: Observable<()>)
    -> Observable<Account>
{
    return action
        >- flatMap { () -> Observable<Account> in
            let stream1 = requestWebAuthUrlStream(defaultConfig())(TWITTER_OAUTH_CALLBACK)
                >- map { (data: [String: String], url: NSURL) in
                    UIApplication.sharedApplication().openURL(url)
                    return data
                }
                >- map(configFromRequestTokenData)

            return combineLatest(stream1, urlObserver) { requestAccessTokenStream($0)($1) }
                >- flattern
                >- catch {
                    sendNext(errorObserver, $0)
                    return empty()
                }
                >- map { data in
                    let account: AccountApiData? = decode(data)
                    let model = AccountModel().fromApiData(account!)
                    let realm = Realm()
                    realm.write {
                        realm.add(model, update: true)
                    }
                    return model.toData()
                }
        }
}
