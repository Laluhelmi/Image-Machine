//
//  Machine.swift
//  Machine Gallery
//
//  Created by laluheri on 10/16/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import Foundation
import RealmSwift
import Photos

class Machine: Object {
    @objc dynamic var id = ""
    @objc dynamic var name: String? = ""
    @objc dynamic var type: String? = ""
    @objc dynamic var qrcode: String? = ""
    @objc dynamic var lastMaintenance : Date?
    var images = List<Image>()
    
    
    override static func primaryKey() -> String {
        return "id"
    }
    
}


extension String{
    func getFileName() -> String{
        let fullPath = self.components(separatedBy: "/")
        return fullPath[0]
    }
    static func randomString(length: Int) -> String {
         let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
         return String((0..<length).map{ _ in letters.randomElement()! })
     }
     
}
