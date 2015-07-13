//
//  TwitterApiService.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/12/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask
import SwiftyJSON

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
            .then { (json, errorInfo) -> Void in
                if let json = json {
                    if json["oauth_callback_confirmed"].boolValue {
                        let oauthToken = json["oauth_token"].stringValue
                        self.twitterApi.oauthToken = oauthToken
                        self.twitterApi.oauthSecret = json["oauth_token_secret"].stringValue

                        let url = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(oauthToken)")!
                        UIApplication.sharedApplication().openURL(url)

                        return
                    }
                }

                assert(false, "oauth_callback_confirmed is not true")
            }
    }

    func handleOauthCallback(url: NSURL) {
        let json = parseQueryParams(url.query!)
        if let requestToken = json["oauth_token"].string {
            let oauthVerifier = json["oauth_verifier"].stringValue
            self.twitterApi.fetch(.OauthAccessToken, params: .OauthVerifier(oauthVerifier))
                .then { (json, errorInfo) -> Void in
                    if let json = json {
                        self.twitterApi.oauthToken = json["oauth_token"].stringValue
                        self.twitterApi.oauthSecret = json["oauth_token_secret"].stringValue

                        println(json.dictionaryValue)
                    }

                    return
                }
        } else {
            // TODO:
        }
    }

}
