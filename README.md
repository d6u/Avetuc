# Avetuc - A Very Easy To Use Client

I often found my friends tweets were buried by account with large amount of posts. The Twitter's home timeline is a classic example of information overload. Though some account posts a lot of usefully information, e.g. Hacker News is favorite. But in addition to Hacker News, I still want to know what my friends are talking about. The thing is, my friends won't tweet a lot. They kept quiet for a some and tweet just once in some random time. It hard to discover those tweets.

So here I created this app called **Avetuc**

## Meaning

This project is no master piece. I had many problems when creating it. It serves more like a learning tool than a valid app (although I have gone ahead submitted :] ). I helped me to understand memory management, reactive programing, and most fun part - Swift. It still has hidden bugs and missing features. So the journey of learning was never ended.

## Architecture

My most proud piece of work is this thing called [River](https://github.com/d6u/Avetuc/blob/master/Avetuc/River/River.swift). It's a manager of streams (that's why I called it River) and event dispatcher. It borrowed concepts of Flux and uses [RxSwift](https://github.com/ReactiveX/RxSwift/) as pillar store. It doesn't look very clear for now, but I plan to extract it into a separate project and make it more useful.
