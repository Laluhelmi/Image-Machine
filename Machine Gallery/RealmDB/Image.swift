//
//  Image.swift
//  Machine Gallery
//
//  Created by laluheri on 10/16/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import Foundation
import RealmSwift

class Image: Object {
    @objc dynamic var id = ""
    @objc dynamic var path = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
}
