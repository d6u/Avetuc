//
//  parseTweet.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

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
    var parts = [String]()

    for e in entities {
        parts.append(string.substringBetweenIndexes(i, e.headIndice))

        switch e {
        case let url as Url:
            parts.append(url.display_url)
        case let media as Media:
            parts.append(media.display_url)
        case let userMention as UserMention:
            parts.append(string.substringBetweenIndexes(e.headIndice, e.tailIndice))
        case let hashtag as Hashtag:
            parts.append(string.substringBetweenIndexes(e.headIndice, e.tailIndice))
        case let extendedMedia as ExtendedMedia:
            if extendedMedia.headIndice < i {
                continue
            }
            parts.append(extendedMedia.display_url)
        default:
            continue
        }

        i = e.tailIndice
    }

    parts.append(string.substringBetweenIndexes(i, count(string)))

    return ParsedTweet(
        tweet: tweet,
        text: join("", parts).stringByReplacingOccurrencesOfString("&amp;", withString: "&"))
}
