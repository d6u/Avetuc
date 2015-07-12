//
//  TwitterAPI.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/12/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Alamofire

class TwitterApi {

    init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }

    let consumerKey: String
    let consumerSecret: String
    var oauthToken: String?
    var oauthSecret: String?

    func fetch(endpoint: TwitterApiEndpoint, params: TwitterApiParam...) -> Request {
        Alamofire.request(self.buildRequest(endpoint, params: params))
            .response { (request, response, data, error) in
                switch endpoint {
                case .OauthRequestToken:

                default:

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
            "oauth_nonce": "16f906900f2ba45bde24a1db55725960", //NSUUID().UUIDString,
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": "1436733623", //String(Int64(NSDate().timeIntervalSince1970)),
            "oauth_version": "1.0",
        ]

        if includeToken {
            dict["oauth_token"] = self.oauthToken!
        }

        return dict
    }

}
