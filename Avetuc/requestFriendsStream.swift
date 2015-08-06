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

func requestFriendIdsStream(account: Account) -> Observable<[String]> {
    return requestStream(configFromAccount(account))(.FriendsIds, [.UserId(account.user_id), .Count(5000), .StringifyIds(true)])
        >- map { data in
            return data["ids"] as! [String]
        }
}

func requestUsersStream(account: Account, ids: [String]) -> Observable<[AnyObject]> {
    return requestStream(configFromAccount(account))(.UsersLookup, [.UserIds(ids), .IncludeEntities(false)])
        >- map { data in
            return data as! [AnyObject]
        }
}

//func requestFriendsStream(account: Account) -> Observable<[User]> {
////    self.twitterApi
////        .friendsIds()
////        .success { data -> FetchAllFriendsTask in
////        }
////        .success { (data: [[UserApiData]]) -> CreateUsersTask in
////            var result = [UserApiData]()
////
////            for users in data {
////                result += users
////            }
////
////            return LocalStorageService.instance.createUsers(result, accountUserId: user_id)
////    }
//}
