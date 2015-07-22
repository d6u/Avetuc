//
//  TwitterApiServiceUtilities.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation

func getHomeTimeline(
    twitterApi: TwitterApi,
    since_id: String?,
    max_id: String?
) -> StatusesHomeTimelineTask
{
    let params: [TwitterApiParam] = [.Count(200), .TrimUser(true), .ExcludeReplies(true), .IncludeEntities(true)]

    return executeGetHomeTimeline(
        twitterApi,
        since_id,
        nil,
        since_id == nil ? params : params + [.SinceId(since_id!)],
        [])
}

func executeGetHomeTimeline(
    twitterApi: TwitterApi,
    since_id: String?,
    max_id: String?,
    params: [TwitterApiParam],
    result: [TweetData]
) -> StatusesHomeTimelineTask
{
    let newParams = max_id == nil ? params : params + [.MaxId(max_id!)]

    return twitterApi.statusesHomeTimeline(newParams)
        .success { (data: [TweetData]) -> StatusesHomeTimelineTask in

            if since_id != nil && data.count > 0 {
                let oldest_tweet_id = data.last!.id_str
                return executeGetHomeTimeline(twitterApi, since_id, String(oldest_tweet_id.toInt()! - 1), params, result + data)
            } else {
                return StatusesHomeTimelineTask(value: result + data)
            }
    }
}
