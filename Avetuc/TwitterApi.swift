//
//  TwitterAPI.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/12/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftTask
import JSONHelper

typealias TwitterApiTask = Task<Progress, TwitterApiResponse, NSError>
typealias ProcessedApiTask = Task<Progress, [String: AnyObject], NSError>

class TwitterApi {

    init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }

    let consumerKey: String
    let consumerSecret: String
    var oauthToken: String?
    var oauthSecret: String?

    func fetch(endpoint: TwitterApiEndpoint, params: TwitterApiParam...) -> TwitterApiTask {
        let task = Alamofire.request(self.buildRequest(endpoint, params: params)).responseAsync()

        return self.processResponse(endpoint, responseTask: task)
            .success { (dict) -> TwitterApiTask in
                switch endpoint {

                case .OauthRequestToken:
                    let tokenData = TokenData(
                        oauth_token: dict["oauth_token"] as! String,
                        oauth_token_secret: dict["oauth_token_secret"] as! String,
                        oauth_callback_confirmed: (dict["oauth_callback_confirmed"] as! String) == "true")
                    return TwitterApiTask(value: tokenData)

                case .OauthAccessToken:
                    let account = AccountData(data: dict)
                    return TwitterApiTask(value: account)

                case .FriendsIds:
                    let ids = FriendsIdsData(data: dict)
                    return TwitterApiTask(value: ids)
                }
            }
    }

    private func processResponse(endpoint: TwitterApiEndpoint, responseTask: AlamofireTask) -> ProcessedApiTask
    {
        return responseTask.success { (data) -> ProcessedApiTask in

            switch endpoint.responseFormat
            {
                case .QueryParam:
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                    let dict = parseQueryParams(str)
                    return ProcessedApiTask(value: dict)

                case .JSON:
                    let dict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as! [String: AnyObject]
                    return ProcessedApiTask(value: dict)
            }
        }

    }

    private func buildRequest(endpoint: TwitterApiEndpoint, params: [TwitterApiParam]) -> URLRequestConvertible {
        let url = NSURL(string: endpoint.url)!
        let mutableUrlRequest = NSMutableURLRequest(URL: url)
        mutableUrlRequest.HTTPMethod = endpoint.method

        let paramDict = paramsToDict(params)
        let authStr = self.authString(endpoint, params: paramDict)
        mutableUrlRequest.setValue(authStr, forHTTPHeaderField: "Authorization")

        return UrlEncoder.encode(mutableUrlRequest, parameters: paramDict).0
    }

    private func authString(endpoint: TwitterApiEndpoint, params: [String: String]) -> String {
        var oauthDict = self.unsignedOauthDict(params, includeToken: endpoint.includeToken)
        let allParams = merge(oauthDict, params)

        var signingKey = urlEncode(self.consumerSecret) + "&"
        if endpoint.includeToken {
            signingKey += urlEncode(self.oauthSecret!)
        }

        oauthDict["oauth_signature"] = generateOauthSignature(endpoint.method, endpoint.url, allParams, signingKey)

        var arr = [String]()
        for key in sorted(oauthDict.keys) {
            let value = oauthDict[key]!
            arr.append(urlEncode(key) + "=\"" + urlEncode(value) + "\"")
        }

        return "OAuth " + join(", ", arr)
    }

    private func unsignedOauthDict(params: [String: String], includeToken: Bool) -> [String: String] {
        var dict = [
            "oauth_consumer_key": self.consumerKey,
            "oauth_nonce": NSUUID().UUIDString,
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": String(Int64(NSDate().timeIntervalSince1970)),
            "oauth_version": "1.0",
        ]

        if includeToken {
            dict["oauth_token"] = self.oauthToken!
        }

        return dict
    }

}
