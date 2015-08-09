import Foundation

/// Tweet data structure with addition of `parsed_text`
class ParsedTweet: Tweet {

    let parsed_text: NSAttributedString

    init(tweet: Tweet, parsed_text: NSAttributedString) {
        self.parsed_text = parsed_text
        
        super.init(
            created_at: tweet.created_at,
            id: tweet.id,
            id_str: tweet.id_str,
            text: tweet.text,
            source: tweet.source,
            truncated: tweet.truncated,
            in_reply_to_status_id: tweet.in_reply_to_status_id,
            in_reply_to_status_id_str: tweet.in_reply_to_status_id_str,
            in_reply_to_user_id: tweet.in_reply_to_user_id,
            in_reply_to_user_id_str: tweet.in_reply_to_user_id_str,
            in_reply_to_screen_name: tweet.in_reply_to_screen_name,
            retweet_count: tweet.retweet_count,
            favorite_count: tweet.favorite_count,
            favorited: tweet.favorited,
            retweeted: tweet.retweeted,
            possibly_sensitive: tweet.possibly_sensitive,
            possibly_sensitive_appealable: tweet.possibly_sensitive_appealable,
            lang: tweet.lang,
            is_read: tweet.is_read,
            retweeted_status: tweet.retweeted_status,
            hashtags: tweet.hashtags,
            urls: tweet.urls,
            user_mentions: tweet.user_mentions,
            medias: tweet.medias,
            extended_medias: tweet.extended_medias)
    }
}
