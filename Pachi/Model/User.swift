//
//  User.swift
//  Pachi
//
//  Created by Takafumi Ogaito on 2019/02/19.
//  Copyright © 2019 Takafumi Ogaito. All rights reserved.
//

import Pring

@objcMembers
class User: Object {
    dynamic var name: String?
    dynamic var thumbnail: File?
    dynamic var posts: NestedCollection<Post> = []
}
