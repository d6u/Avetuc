//
//  River.swift
//  Avetuc
//
//  Created by Daiwei Lu on 8/4/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import LarryBird
import Argo

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

class River {
    static let instance = River()

    init() {
        let requestTokenStream = self.addAccountFromWebAction
            >- flatMap { () -> Observable<JSONDict> in
                let config = Config(
                    consumerKey: TWITTER_CONSUMER_KEY,
                    consumerSecret: TWITTER_CONSUMER_SECRET,
                    oauthToken: nil,
                    oauthSecret: nil)
                return requestStream(config)(.OauthRequestToken, [.OauthCallback(TWITTER_OAUTH_CALLBACK)])
            }
            >- map { (data: JSONDict) -> Config in
                return Config(
                    consumerKey: TWITTER_CONSUMER_KEY,
                    consumerSecret: TWITTER_CONSUMER_SECRET,
                    oauthToken: data["oauth_token"] as? String,
                    oauthSecret: data["oauth_token_secret"] as? String)
            }

        let addAccountStream = zip(requestTokenStream, self.handleOauthCallbackAction)
            { config, url -> Observable<JSONDict> in
                return requestAccessTokenStream(config)(url)
            }
            >- map { data -> Account? in
                let account: AccountApiData? = decode(data)
                let model = AccountModel().fromApiData(account!)
                let realm = Realm()
                realm.write {
                    realm.add(model, update: true)
                }
                return model.toData()
            }

//        let loadAccount
//            >- catch { err in
//                println(err)
//                return failWith(err)
//            }
//            >- retry


    }

    let addAccountFromWebAction = PublishSubject<Void>()
    let handleOauthCallbackAction = PublishSubject<NSURL>()

    let defaultAccountStream: ConnectableObservableType<Account?> = {
        let account = Realm().objects(AccountModel).first?.toData()
        return just(account) >- publish
    }()
}
