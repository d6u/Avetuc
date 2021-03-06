# Avetuc - A Very Easy To Use Client

I often found my friends' tweets buried by large amount of news account or other active users. Twitter's timeline design is a classic example of information overload. Although some accounts post a lot of useful information, e.g. Hacker News. But besides Hacker News, I also want to know what my friends are talking about. The thing is, my friends don't tweet a lot. They usually keep quiet for a while and tweet once in random. It's hard to discover those tweets.

That's why I created this app called **Avetuc**.

## Meaning

This project is no master piece. I had many problems while making it. It serves more like a learning experience than a valid app (although I have gone ahead submitted to App Store :] ). It helped me to understand memory management, reactive programing, and most interesting language - Swift. It still has hidden bugs and missing features. So the journey of learning was never ended.

## Run The App

First of all you should install dependencies.
```sh
pod install
```

Then you need a `Secrets.swift` file under `./Avetuc` directory that looks like:
```swift
import Foundation

let TWITTER_CONSUMER_KEY = "xxxxxxxxxxxxxxxxxxx"
let TWITTER_CONSUMER_SECRET = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
let TWITTER_OAUTH_CALLBACK = "zzzz://zzzzzzzzzzzzzzzz"
```

Of cause, you should have already registered an app with Twitter app manager.

When all done, open workspace and start hacking.

## Architecture

My most proud piece is this thing called [River](https://github.com/d6u/Avetuc/blob/master/Avetuc/River/River.swift). It's a manager of streams (that's why I named it River) and event dispatcher. It borrowed concepts from Flux and used [RxSwift](https://github.com/ReactiveX/RxSwift/) as pillar store. It doesn't look very clear for now, but I plan to extract it into a separate project and make it more useful.

## Issues & Bugs

I record bugs and future features in PivotalTracker https://www.pivotaltracker.com/n/projects/1356996. But issues and PRs on Github are still welcome!
