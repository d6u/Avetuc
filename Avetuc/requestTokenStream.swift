//
//  requestTokenStream.swift
//  Avetuc
//
//  Created by Daiwei Lu on 8/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RxSwift
import LarryBird

func createRequestTokenStream(action_addAccountFromWeb: PublishSubject<Void>) -> Observable<Config> {
    return action_addAccountFromWeb
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
}
