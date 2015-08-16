import Foundation

class LoadedObjects {

    static let instance = LoadedObjects()

    private var users = [Int64: User]()
    private var tweets = [Int64: Tweet]()

    func addUsers(users: [User]) {
        for user in users {
            if self.users[user.id] == nil {
                self.users[user.id] = user
            }
        }
    }

    func addTweets(tweets: [Tweet]) {
        for tweet in tweets {
            if self.tweets[tweet.id] == nil {
                self.tweets[tweet.id] = tweet
            }
        }
    }

    func getLoadedTweets(tweets: [Tweet]) -> [Tweet] {
        self.addTweets(tweets)
        return tweets.map { self.getTweet($0.id)! }
    }

    func getLoadedUsers(users: [User]) -> [User] {
        self.addUsers(users)
        return users.map { self.getUser($0.id)! }
    }

    func getUser(id: Int64) -> User? {
        return self.users[id]
    }

    func getTweet(id: Int64) -> Tweet? {
        return self.tweets[id]
    }

}
