import Foundation

class TweetCellData: Equatable {

    let tweet: Tweet
    var text: NSAttributedString?

    init(tweet: Tweet, text: NSAttributedString?) {
        self.tweet = tweet
        self.text = text
    }
}

func ==(lhs: TweetCellData, rhs: TweetCellData) -> Bool {
    return lhs.tweet == rhs.tweet
}
