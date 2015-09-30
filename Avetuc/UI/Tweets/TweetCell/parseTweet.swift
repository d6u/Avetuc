import UIKit

let TEXT_LINK_ATTR_NAME = "TEXT_LINK_ATTR_NAME"

func parseTweetText(tweet: Tweet) -> NSAttributedString {

    let string = tweet.text

    var entities = [GeneralEntity]()

    if let _entities = tweet.entities {
        for e in _entities.urls {
            entities.append(e)
        }

        for e in _entities.user_mentions {
            entities.append(e)
        }

        for e in _entities.hashtags {
            entities.append(e)
        }

        for e in _entities.media {
            entities.append(e)
        }
    }

    if let extendedEntities = tweet.extended_entities {
        for e in extendedEntities.media {
            entities.append(e)
        }
    }

    entities.sortInPlace { (a: GeneralEntity, b: GeneralEntity) -> Bool in
        return a._indices.head < b._indices.head
    }

    var i = 0
    var j = 0
    var parts = [String]()
    var attri = [(NSObject, AnyObject, Int, Int)]()

    for e in entities {
        parts.append(string.substringBetweenIndexes(i, e._indices.head))

        j += e._indices.head - i

        let l: Int
        var link: String?
        let color: UIColor

        switch e {
        case let url as UrlEntity:
            parts.append(url.display_url)
            l = url.display_url.characters.count
            link = url.expanded_url
            color = UIColor(netHex: 0x549AE6)
        case let media as MediaEntity:
            parts.append(media.display_url)
            l = media.display_url.characters.count
            color = UIColor(netHex: 0x549AE6)
        case let userMention as UserMentionEntity:
            parts.append(string.substringBetweenIndexes(e._indices.head, e._indices.tail))
            l = e._indices.tail - e._indices.head
            link = "https://twitter.com/\(userMention.screen_name)"
            color = UIColor(netHex: 0x549AE6)
        case let hashtag as HashtagEntity:
            parts.append(string.substringBetweenIndexes(e._indices.head, e._indices.tail))
            l = e._indices.tail - e._indices.head
            link = "https://twitter.com/hashtag/\(hashtag.text)"
            color = UIColor(netHex: 0x999999)
        case let extendedMedia as MediaEntityExtended:
            if extendedMedia._indices.head < i {
                continue
            }
            parts.append(extendedMedia.display_url)
            l = extendedMedia.display_url.characters.count
            color = UIColor(netHex: 0x549AE6)
        default:
            continue
        }

        attri.append((NSForegroundColorAttributeName, color, j, j + l))

        if let link = link {
            attri.append((TEXT_LINK_ATTR_NAME, link, j, j + l))
        }

        i = e._indices.tail
        j += l
    }

    parts.append(string.substringBetweenIndexes(i, string.characters.count))

    // Cannot use `join("", parts)`
    // because it will hang when string has contry flag emoji
    // e.g. "🇬🇧 LHR ✈️ SFO 🇺🇸"
    let parsedString = (parts as NSArray).componentsJoinedByString("")

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

    text.replaceOccurrencesOfString("&amp;", withString: "&")
    text.replaceOccurrencesOfString("&lt;", withString: "<")
    text.replaceOccurrencesOfString("&gt;", withString: ">")

    return text
}

protocol GeneralEntity {
    var _indices: EntityIndices { get }
}

extension UrlEntity: GeneralEntity {
    var _indices: EntityIndices {
        return self.indices!
    }
}

extension HashtagEntity: GeneralEntity {
    var _indices: EntityIndices {
        return self.indices!
    }
}

extension UserMentionEntity: GeneralEntity {
    var _indices: EntityIndices {
        return self.indices!
    }
}

extension MediaEntity: GeneralEntity {
    var _indices: EntityIndices {
        return self.indices!
    }
}

extension MediaEntityExtended: GeneralEntity {
    var _indices: EntityIndices {
        return self.indices!
    }
}
