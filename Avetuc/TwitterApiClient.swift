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
import Argo

typealias FetchTask = Task<Float, AnyObject, NSError>

class TwitterApiClient {

    init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }

    init(consumerKey: String, consumerSecret: String, oauthToken: String, oauthTokenSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
    }

    private let consumerKey: String
    private let consumerSecret: String
    private var oauthToken: String?
    private var oauthTokenSecret: String?

    func loadTokens(oauthToken: String, oauthTokenSecret: String) {
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
    }

    func fetch(endpoint: TwitterApiEndpoint, params: [TwitterApiParam]) -> FetchTask {

        if DISABLE_TWITTER_API_CALLS {
            let err = NSError(domain: "com.daiweilu.Avtuc", code: 123, userInfo: ["desc": "API Request is blocked due to configuration"])
            println(err)
            println("Blocked request to \(endpoint.rawValue)")
            return FetchTask(error: err)
        }

        let task = Alamofire.request(self.buildRequest(endpoint, params: params)).response()
        return process(task, endpoint)
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
            signingKey += urlEncode(self.oauthTokenSecret!)
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

func process(task: RequestTask, endpoint: TwitterApiEndpoint) -> FetchTask
{
    return task.success { data -> FetchTask in

        switch endpoint.responseFormat {

        case .QueryParam:
            let json = parseQueryParams(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
            return FetchTask(value: json)

        case .JSON:
            let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil)
            return FetchTask(value: json!)
        }
    }
}
