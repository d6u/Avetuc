//
//  ExtendedMediaEntityModel.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/22/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import RealmSwift

class ExtendedMediaEntityModel: Object {

    dynamic var id: Int64 = -1
    dynamic var id_str: String = ""
    dynamic var media_url: String = ""
    dynamic var media_url_https: String = ""
    dynamic var url: String = ""
    dynamic var display_url: String = ""
    dynamic var expanded_url: String = ""
    dynamic var type: String = ""

    dynamic var head_indices: Int64 = -1
    dynamic var tail_indices: Int64 = -1

    dynamic var small_size: SizeModel?
    dynamic var large_size: SizeModel?
    dynamic var thumb_size: SizeModel?
    dynamic var medium_size: SizeModel?

    func fromApiData(data: ExtendedMediaApiData) -> ExtendedMediaEntityModel {
        self.id = data.id
        self.id_str = data.id_str
        self.media_url = data.media_url
        self.media_url_https = data.media_url_https
        self.url = data.url
        self.display_url = data.display_url
        self.expanded_url = data.expanded_url
        self.type = data.type
        self.head_indices = data.indices[0]
        self.tail_indices = data.indices[1]

        self.small_size = SizeModel().fromApiData(.Small, data: data.sizes.small)
        self.large_size = SizeModel().fromApiData(.Large, data: data.sizes.large)
        self.thumb_size = SizeModel().fromApiData(.Thumb, data: data.sizes.thumb)
        self.medium_size = SizeModel().fromApiData(.Medium, data: data.sizes.medium)

        return self
    }

    func toData() -> ExtendedMedia {
        return ExtendedMedia(
            id: id,
            id_str: id_str,
            media_url: media_url,
            media_url_https: media_url_https,
            url: url,
            display_url: display_url,
            expanded_url: expanded_url,
            type: type,
            head_indices: head_indices,
            tail_indices: tail_indices,
            small_size: small_size!.toData(),
            large_size: large_size!.toData(),
            thumb_size: thumb_size!.toData(),
            medium_size: medium_size!.toData()
        )
    }

}
