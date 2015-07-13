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
import SwiftyJSON

typealias Progress = (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
typealias TwitterApiTask = Task<Progress, JSON, NSError>

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
        return TwitterApiTask { progress, fulfill, reject, configure in
            Alamofire
                .request(self.buildRequest(endpoint, params: params))
                .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                    progress((bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) as Progress)
                }
                .response { request, response, data, error in
                    if let error = error {
                        reject(error)
                        return
                    }

                    switch endpoint {
                    case .OauthRequestToken: fallthrough
                    case .OauthAccessToken:
                        let json = parseQueryParams(NSString(data: data as! NSData, encoding: NSUTF8StringEncoding) as! String)
                        fulfill(json)
                    }
                }

            return
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
