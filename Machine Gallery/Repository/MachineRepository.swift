//
//  MachineRepository.swift
//  Machine Gallery
//
//  Created by laluheri on 10/16/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import Foundation
import RealmSwift
import Photos


class MachineServiceImpl : MachineService{
   
    // Get the default Realm
    let realm = try! Realm()
    
    func addMachine(machine: Machine){
        try! realm.write {
        realm.add(machine)
        }
    }
    
    func updateMachine(updateCallback: (() -> ())) {
        try! realm.write {
            updateCallback()
        }
    }
    
    func findMachine(qrCode: String) -> Machine?{
        let data = realm.objects(Machine.self).filter("qrcode ='"+qrCode+"'").first
        return data
    }
    
    func deleteMachine(machine: Machine) {
        try! realm.write {
            realm.delete(machine)
        }
    }
    
    func deleteImage(path: String) {
        let image = realm.objects(Image.self).filter("path ='"+path+"'")
        try! realm.write {
            realm.delete(image)
        }
    }
    
    func fetchMachines() -> Results<Machine> {
        
        return realm.objects(Machine.self).sorted(byKeyPath: "name", ascending: true)
        
    }
    
    func sortMachine(sortBy: String) -> Results<Machine> {
        return realm.objects(Machine.self).sorted(byKeyPath: sortBy, ascending: true)
    }
}
