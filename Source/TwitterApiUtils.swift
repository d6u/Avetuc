//
//  TwitterApiUtils.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/12/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

func paramsToDict(params: [TwitterApiParam]) -> [String: String] {
    var dict = [String: String]()
    for param in params {
        let (key, value) = param.keyValuePair
        dict[key] = value
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

let UrlEncoder = Alamofire.ParameterEncoding.Custom { (request, params) -> (NSURLRequest, NSError?) in

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

func parseQueryParams(queryStr: String) -> JSON {
    let pairs = queryStr.componentsSeparatedByString("&")
    var dict = [String: String]()
    for pair in pairs {
        let keyValue = pair.componentsSeparatedByString("=")
        dict[keyValue[0]] = keyValue[1]
    }
    return JSON(dict)
}
