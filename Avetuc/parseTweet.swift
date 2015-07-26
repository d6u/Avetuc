//
//  parseTweet.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func substringToIndex(index: Int) -> String {
        return self.substringToIndex(advance(self.startIndex, index))
    }

    func substringFromIndex(index: Int) -> String {
        return self.substringFromIndex(advance(self.startIndex, index))
    }

    func substringBetweenIndexes(begin: Int, _ end: Int) -> String {
        let substring = self.substringToIndex(end)
        return substring.substringFromIndex(begin)
    }
    
}

protocol TweetEntity {
    var headIndice: Int { get }
    var tailIndice: Int { get }
}

extension Url: TweetEntity {
    var headIndice: Int {
        return Int(self.indices[0])
    }
    var tailIndice: Int {
        return Int(self.indices[1])
    }
}

extension Hashtag: TweetEntity {
    var headIndice: Int {
        return Int(self.indices[0])
    }
    var tailIndice: Int {
        return Int(self.indices[1])
    }
}

extension UserMention: TweetEntity {
    var headIndice: Int {
        return Int(self.indices[0])
    }
    var tailIndice: Int {
        return Int(self.indices[1])
    }
}

extension Media: TweetEntity {
    var headIndice: Int {
        return Int(self.head_indices)
    }
    var tailIndice: Int {
        return Int(self.tail_indices)
    }
}

extension ExtendedMedia: TweetEntity {
    var headIndice: Int {
        return Int(self.head_indices)
    }
    var tailIndice: Int {
        return Int(self.tail_indices)
    }
}

func parseTweet(tweet: Tweet) -> ParsedTweet {

    let string = tweet.text

    var entities = [TweetEntity]()

    for e in tweet.urls {
        entities.append(e)
    }

    for e in tweet.user_mentions {
        entities.append(e)
    }

    for e in tweet.hashtags {
        entities.append(e)
    }

    for e in tweet.medias {
        entities.append(e)
    }

    for e in tweet.extended_medias {
        entities.append(e)
    }

    entities.sort { (a: TweetEntity, b: TweetEntity) -> Bool in
        return a.headIndice < b.headIndice
    }

    var i = 0
    var j = 0
    var parts = [String]()
    var attri = [(NSObject, AnyObject, Int, Int)]()

    for e in entities {
        parts.append(string.substringBetweenIndexes(i, e.headIndice))

        j += e.headIndice - i
        let l: Int

        switch e {
        case let url as Url:
            parts.append(url.display_url)
            l = count(url.display_url)
            attri.append((NSForegroundColorAttributeName, UIColor(netHex: 0x549AE6), j, j + l))
        case let media as Media:
            parts.append(media.display_url)
            l = count(media.display_url)
            attri.append((NSForegroundColorAttributeName, UIColor(netHex: 0x549AE6), j, j + l))
        case let userMention as UserMention:
            parts.append(string.substringBetweenIndexes(e.headIndice, e.tailIndice))
            l = e.tailIndice - e.headIndice
            attri.append((NSForegroundColorAttributeName, UIColor(netHex: 0x549AE6), j, j + l))
        case let hashtag as Hashtag:
            parts.append(string.substringBetweenIndexes(e.headIndice, e.tailIndice))
            l = e.tailIndice - e.headIndice
            attri.append((NSForegroundColorAttributeName, UIColor(netHex: 0x999999), j, j + l))
        case let extendedMedia as ExtendedMedia:
            if extendedMedia.headIndice < i {
                continue
            }
            parts.append(extendedMedia.display_url)
            l = count(extendedMedia.display_url)
            attri.append((NSForegroundColorAttributeName, UIColor(netHex: 0x549AE6), j, j + l))
        default:
            continue
        }

        i = e.tailIndice
        j += l
    }

    parts.append(string.substringBetweenIndexes(i, count(string)))

    let parsedString = join("", parts)//.stringByReplacingOccurrencesOfString("&amp;", withString: "&")

    let text = NSMutableAttributedString(string: parsedString, attributes: [
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15)!,
            NSParagraphStyleAttributeName: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                paragraphStyle.lineBreakMode = .ByWordWrapping
                return paragraphStyle
            }()
        ])

    for (key, value, head, tail) in attri {
        text.addAttributes([key: value], range: NSMakeRange(head, tail - head))
    }

    return ParsedTweet(tweet: tweet, text: text)
}
