import Foundation
import RxSwift
import LarryBird
import RealmSwift
import Argo

func createCreateAccountStream(
    requestTokenStream: Observable<Config>,
    action_handleOauthCallback: PublishSubject<NSURL>,
    stream_addAccountError: PublishSubject<NSError>) -> Observable<Account?>
{
    return zip(requestTokenStream, action_handleOauthCallback) { config, url -> Observable<AnyObject> in
        return requestAccessTokenStream(config)(url)
    }
        >- flattern
        >- redirectError(stream_addAccountError)
        >- map { data -> Account? in
            let account: AccountApiData? = decode(data)
            let model = AccountModel().fromApiData(account!)
            let realm = Realm()
            realm.write {
                realm.add(model, update: true)
            }
            return model.toData()
    }
}
