//
//  Post.swift
//  Pachi
//
//  Created by Takafumi Ogaito on 2019/02/19.
//  Copyright © 2019 Takafumi Ogaito. All rights reserved.
//

import Pring

@objcMembers
class Post: Object {
    dynamic var images: [File?] = []
    dynamic var subject: String?
    dynamic var body: String?
    dynamic var user: User?
    dynamic var latitude: String?
    dynamic var longitude: String?
}