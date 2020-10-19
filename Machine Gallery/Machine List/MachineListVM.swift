//
//  MachineListVM.swift
//  Machine Gallery
//
//  Created by laluheri on 10/17/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


enum SortBy {
    case name
    case type
}

class MachineListVM : NSObject{
    
    var service : MachineService!
    
    
    weak var tableView : UITableView?
    
    var didSelectCell : ((Int) -> ())?
    var onEditButtonTap : ((Int) -> ())?
    var onDeleteButtonTap : ((Int) -> ())?
    
    var sortyBy : SortBy!{
        didSet{
            switch sortyBy {
            case .name:
                self.sortMachine(sortBy: "name")
                break
            default:
                self.sortMachine(sortBy: "type")
                break
            }
        }
    }
    
    
    var machinies : [Machine]{
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    
    init(service: MachineService) {
        self.service   = service
        self.machinies = Array(self.service.fetchMachines())
    }
    
    func refreshFetching(){
        self.machinies = Array(self.service.fetchMachines())
    }
    
    func sortMachine(sortBy: String){
        self.machinies = Array(self.service.sortMachine(sortBy: sortBy))
    }
    
    func deleteMachine(index: Int){
        self.service.deleteMachine(machine: self.machinies[index])
        self.machinies.remove(at: index)
    }
    
}

extension MachineListVM : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.machinies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectCell?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "machinecell", for: indexPath) as! MachineTableVewCell
        let data = self.machinies[indexPath.row]
        cell.name.text = data.name
        cell.selectionStyle = .none
        cell.type.text = data.type
        
        cell.onEditButtonTap = {
            self.onEditButtonTap?(indexPath.row)
        }
        cell.onDeleteButtonTap = {
            self.onDeleteButtonTap?(indexPath.row)
        }
        
        return cell
    }
    
    
    
}
