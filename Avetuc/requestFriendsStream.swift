//
//  requestFriendsStream.swift
//  Avetuc
//
//  Created by Daiwei Lu on 8/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RxSwift
import LarryBird

func requestFriendsStream(account: Account) -> Observable<[User]> {
    let config = Config(
        consumerKey: TWITTER_CONSUMER_KEY,
        consumerSecret: TWITTER_CONSUMER_SECRET,
        oauthToken: account.oauth_token,
        oauthSecret: account.oauth_token_secret)
    requestStream(config)(.FriendsIds, [.UserId(account.user_id), .Count(5000), .StringifyIds(true)])
        >- map { data -> Observable<Observable<JSONDict>> in
            let ids = data["ids"] as! [String]
            var batch = [[String]]()
            var i = 0

            while i < ids.count {
                let end = min(i + 100, ids.count)
                batch.append(Array(ids[i..<end]))
                i += 100
            }

            let tasks = batch.map { (ids: [String]) -> UsersLookupTask in
                return usersLookup([.UserIds(ids), .IncludeEntities(false)])
            }

            return UsersLookupTask.all(tasks)
        }
//    self.twitterApi
//        .friendsIds()
//        .success { data -> FetchAllFriendsTask in
//        }
//        .success { (data: [[UserApiData]]) -> CreateUsersTask in
//            var result = [UserApiData]()
//
//            for users in data {
//                result += users
//            }
//
//            return LocalStorageService.instance.createUsers(result, accountUserId: user_id)
//    }
}
