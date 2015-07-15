//
//  TwitterApiService.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/12/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask

class TwitterApiService {

    class var instance: TwitterApiService {
        struct Static {
            static var instance: TwitterApiService?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = TwitterApiService()
        }
        return Static.instance!
    }

    let twitterApi = TwitterApi(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)

    func addAccountThroughWeb() {
        self.twitterApi.fetch(.OauthRequestToken, params: .OauthCallback(TWITTER_OAUTH_CALLBACK))
            .success { (response: TwitterApiResponse) -> Void in
                let data = response as! TokenData
                self.twitterApi.oauthToken = data.oauth_token
                self.twitterApi.oauthSecret = data.oauth_token_secret
                let url = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(data.oauth_token)")!
                UIApplication.sharedApplication().openURL(url)
            }
    }

    func handleOauthCallback(url: NSURL) {
        let dict = parseQueryParams(url.query!)
        println(dict)
//        if let requestToken = json["oauth_token"].string {
//            let oauthVerifier = json["oauth_verifier"].stringValue
//            self.twitterApi.fetch(.OauthAccessToken, params: .OauthVerifier(oauthVerifier))
//                .then { (json, errorInfo) -> Void in
//                    if let json = json {
//                        self.twitterApi.oauthToken = json["oauth_token"].stringValue
//                        self.twitterApi.oauthSecret = json["oauth_token_secret"].stringValue
//
//                        let accountData = AccountData(
//                            oauth_token: json["oauth_token"].stringValue,
//                            oauth_token_secret: json["oauth_token_secret"].stringValue,
//                            user_id: json["user_id"].stringValue,
//                            screen_name: json["screen_name"].stringValue
//                        )
//
//                        
//                    }
//
//                    return
//                }
//        } else {
//            // TODO:
//        }
    }

}
