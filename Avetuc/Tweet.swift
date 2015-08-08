import Foundation

class Tweet {

    let created_at: String
    let id: Int64
    let id_str: String
    let text: String
    let source: String
    let truncated: Bool
    let in_reply_to_status_id: Int64?
    let in_reply_to_status_id_str: String?
    let in_reply_to_user_id: Int64?
    let in_reply_to_user_id_str: String?
    let in_reply_to_screen_name: String?
    let retweet_count: Int64
    let favorite_count: Int64
    let favorited: Bool
    let retweeted: Bool
    let possibly_sensitive: Bool
    let possibly_sensitive_appealable: Bool
    let lang: String

    let is_read: Bool

    let retweeted_status: Tweet?
    let hashtags: [Hashtag]
    let urls: [Url]
    let user_mentions: [UserMention]
    let medias: [Media]
    let extended_medias: [ExtendedMedia]

    init(
        created_at: String,
        id: Int64,
        id_str: String,
        text: String,
        source: String,
        truncated: Bool,
        in_reply_to_status_id: Int64?,
        in_reply_to_status_id_str: String?,
        in_reply_to_user_id: Int64?,
        in_reply_to_user_id_str: String?,
        in_reply_to_screen_name: String?,
        retweet_count: Int64,
        favorite_count: Int64,
        favorited: Bool,
        retweeted: Bool,
        possibly_sensitive: Bool,
        possibly_sensitive_appealable: Bool,
        lang: String,
        is_read: Bool,
        retweeted_status: Tweet?,
        hashtags: [Hashtag],
        urls: [Url],
        user_mentions: [UserMention],
        medias: [Media],
        extended_medias: [ExtendedMedia])
    {
        self.created_at = created_at
        self.id = id
        self.id_str = id_str
        self.text = text
        self.source = source
        self.truncated = truncated
        self.in_reply_to_status_id = in_reply_to_status_id
        self.in_reply_to_status_id_str = in_reply_to_status_id_str
        self.in_reply_to_user_id = in_reply_to_user_id
        self.in_reply_to_user_id_str = in_reply_to_user_id_str
        self.in_reply_to_screen_name = in_reply_to_screen_name
        self.retweet_count = retweet_count
        self.favorite_count = favorite_count
        self.favorited = favorited
        self.retweeted = retweeted
        self.possibly_sensitive = possibly_sensitive
        self.possibly_sensitive_appealable = possibly_sensitive_appealable
        self.lang = lang
        self.is_read = is_read
        self.retweeted_status = retweeted_status
        self.hashtags = hashtags
        self.urls = urls
        self.user_mentions = user_mentions
        self.medias = medias
        self.extended_medias = extended_medias
    }

}
