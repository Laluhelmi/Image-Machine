//
//  MachineService.swift
//  Machine Gallery
//
//  Created by laluheri on 10/16/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import Foundation
import RealmSwift

protocol MachineService {
    
    
    func addMachine(machine: Machine)
    func deleteMachine(machine: Machine)
    func deleteImage(path: String)
    func fetchMachines() -> Results<Machine>
    func updateMachine(updateCallback: (()->()))
    func sortMachine(sortBy: String) -> Results<Machine>
    func findMachine(qrCode: String) -> Machine?
    
}
