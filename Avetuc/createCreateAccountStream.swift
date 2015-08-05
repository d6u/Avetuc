//
//  createCreateAccountStream.swift
//  Avetuc
//
//  Created by Daiwei Lu on 8/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

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
    return zip(requestTokenStream, action_handleOauthCallback) { config, url -> Observable<JSONDict> in
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
            let account: AccountApiData? = decode(data)
            let model = AccountModel().fromApiData(account!)
            let realm = Realm()
            realm.write {
                realm.add(model, update: true)
            }
            return model.toData()
    }
}
