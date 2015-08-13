import Foundation
import LarryBird

func defaultConfig() -> Config {
    return Config(
        consumerKey: TWITTER_CONSUMER_KEY,
        consumerSecret: TWITTER_CONSUMER_SECRET,
        oauthToken: nil,
        oauthSecret: nil)
}

func configFromRequestTokenData(data: AnyObject) -> Config {
    let dict = data as? [String: String]
    return Config(
        consumerKey: TWITTER_CONSUMER_KEY,
        consumerSecret: TWITTER_CONSUMER_SECRET,
        oauthToken: dict?["oauth_token"],
        oauthSecret: dict?["oauth_token_secret"])
}

func configFromAccount(account: Account) -> Config {
    return Config(
        consumerKey: TWITTER_CONSUMER_KEY,
        consumerSecret: TWITTER_CONSUMER_SECRET,
        oauthToken: account.oauth_token,
        oauthSecret: account.oauth_token_secret)
}
