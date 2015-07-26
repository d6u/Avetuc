//
//  TwitterApiUtils.swift
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

func paramsToDict(params: [TwitterApiParam]) -> [String: String] {
    var dict = [String: String]()
    for param in params {
        let pair = param.pair
        dict[pair.key] = pair.value
    }
    return dict
}

func merge(left: [String: String], right: [String: String]) -> [String: String] {
    var target = left
    for (k, v) in right {
        target.updateValue(v, forKey: k)
    }
    return target
}

func generateOauthSignature(method: String, url: String, params: [String: String], signingKey: String) -> String {
    var arr = [String]()
    for key in sorted(params.keys) {
        let value = params[key]!
        arr.append(urlEncode(key) + "=" + urlEncode(value))
    }
    let paramStr = join("&", arr)
    let baseStr = method + "&" + urlEncode(url) + "&" + urlEncode(paramStr)
    return sha1DigestString(baseStr, signingKey)
}

private let charactersToBeEscaped = ":/?&=;+!@#$()',*" as CFStringRef
private let charactersToLeaveUnescaped = "[]." as CFStringRef

func urlEncode(str: String) -> String {
    return CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        str as CFString,
        charactersToLeaveUnescaped,
        charactersToBeEscaped,
        CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) as String
}

func sha1DigestString(baseStr: String, key: String) -> String {
    let str = baseStr.cStringUsingEncoding(NSUTF8StringEncoding)
    let strLen = baseStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

    let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<Void>.alloc(digestLen)

    let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)!
    let keyLen = key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyStr, keyLen, str!, strLen, result)

    return NSData(bytes: result, length: digestLen).base64EncodedStringWithOptions(nil)
}

let UrlEncoder = Alamofire.ParameterEncoding.Custom {
    (request: URLRequestConvertible, params: [String : AnyObject]?) -> (NSMutableURLRequest, NSError?) in

    let mutableUrlRequest = request.URLRequest.mutableCopy() as! NSMutableURLRequest

    var arr = [String]()
    for (key, value) in params as! [String: String] {
        arr.append(urlEncode(key) + "=" + urlEncode(value))
    }
    let paramStr = join("&", arr)

    switch mutableUrlRequest.HTTPMethod {
    case "GET":
        let urlComponents = NSURLComponents(URL: mutableUrlRequest.URL!, resolvingAgainstBaseURL: false)!
        urlComponents.percentEncodedQuery = paramStr
        mutableUrlRequest.URL = urlComponents.URL
    case "POST":
        mutableUrlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        mutableUrlRequest.HTTPBody = paramStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    default:
        assert(false, "Only support GET and POST")
    }

    return (mutableUrlRequest, nil)
}

func parseQueryParams(queryStr: String) -> [String: String] {
    let pairs = queryStr.componentsSeparatedByString("&")
    var dict = [String: String]()
    for pair in pairs {
        let keyValue = pair.componentsSeparatedByString("=")
        dict[keyValue[0]] = keyValue[1]
    }
    return dict
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

func parseError<T>(endpoint: TwitterApiEndpoint, decoded: Decoded<T>) -> NSError {
    return NSError(domain: "com.daiweilu.Avetuc", code: 1, userInfo: ["desc": decoded.description])
}

func parseOauthCallback(url: NSURL) -> OauthCallbackData {
    let dict = parseQueryParams(url.query!)
    let callbackData: OauthCallbackData? = decode(dict)
    return callbackData!
}
