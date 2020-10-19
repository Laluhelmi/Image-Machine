//
//  CostumClass.swift
//  Machine Gallery
//
//  Created by laluheri on 10/15/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import Foundation
import UIKit
class Test {
    
    var name: String?
    var email: String?
    weak var controller: UIViewController?
    
    init(name: String,email: String,controller: UIViewController) {
        self.name = name
        self.email = email
        self.controller = controller
    }
    
    deinit {
        print("test deinit called")
    }
}
