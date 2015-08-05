import Foundation
import RxSwift
import RealmSwift
import LarryBird
import Argo

class River {
    static let instance = River()

    init() {
        let stream_addAccountError = self.stream_addAccountError

        let requestTokenStream = self.action_addAccountFromWeb
            >- flatMap { () -> Observable<JSONDict> in
                let config = Config(
                    consumerKey: TWITTER_CONSUMER_KEY,
                    consumerSecret: TWITTER_CONSUMER_SECRET,
                    oauthToken: nil,
                    oauthSecret: nil)
                return requestStream(config)(.OauthRequestToken, [.OauthCallback(TWITTER_OAUTH_CALLBACK)])
            }
            >- doOrDie { event in
                switch event {
                case .Next(let box):
                    if let token = box.value["oauth_token"] as? String {
                        let url = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(token)")!
                        UIApplication.sharedApplication().openURL(url)
                    } else {
                        return .Failure(UnknownError)
                    }
                default:
                    break
                }

                return .Success(RxBox<Void>())
            }
            >- map { (data: JSONDict) -> Config in
                return Config(
                    consumerKey: TWITTER_CONSUMER_KEY,
                    consumerSecret: TWITTER_CONSUMER_SECRET,
                    oauthToken: data["oauth_token"] as? String,
                    oauthSecret: data["oauth_token_secret"] as? String)
            }

        let createAccountStream = zip(requestTokenStream, self.action_handleOauthCallback) { config, url -> Observable<JSONDict> in
                return requestAccessTokenStream(config)(url)
            }
            >- flatMap { (observable: Observable<JSONDict>) in
                return observable
            }
            >- `do` { event -> Void in
                switch event {
                case .Error(let err):
                    println("createAccountStream error: \(err)")
                    sendNext(stream_addAccountError, err)
                default:
                    break
                }
            }
            >- retry
            >- map { data -> Account? in
                println("map \(data)")
                let account: AccountApiData? = decode(data)
                let model = AccountModel().fromApiData(account!)
                let realm = Realm()
                realm.write {
                    realm.add(model, update: true)
                }
                return model.toData()
            }

        self.stream_account = merge(returnElements(createAccountStream, defaultAccount())) >- replay(1)
        self.stream_account.connect()
    }

    let action_addAccountFromWeb = PublishSubject<Void>()
    let action_handleOauthCallback = PublishSubject<NSURL>()

    let stream_addAccountError = PublishSubject<NSError>()
    let stream_account: ConnectableObservableType<Account?>
}
