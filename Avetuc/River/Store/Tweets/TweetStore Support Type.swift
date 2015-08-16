import Foundation

struct TweetCellData: Equatable {
    let tweet: Tweet
    let text: NSAttributedString
}

func ==(lhs: TweetCellData, rhs: TweetCellData) -> Bool {
    return lhs.tweet == rhs.tweet
}
