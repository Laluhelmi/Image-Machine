//
//  MachineListVC.swift
//  Machine Gallery
//
//  Created by laluheri on 10/16/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos

class MachineListVC: UIViewController {

    @IBOutlet weak var machineTableView: UITableView!
    @IBOutlet weak var sortByTypeButton: UIButton!
    @IBOutlet weak var sortByNameButton: UIButton!
    
    let viewModel = MachineListVM(service: MachineServiceImpl())
    
    let rowHeight = CGFloat(50.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControllerButton()
        self.initTableView()
        //sort by name selected
        self.sortByNameButton.alpha = 0.2
    }
    
    deinit {
        print("deinit MachineListVC")
    }
    
    func initControllerButton(){
        let addDataButton = UIBarButtonItem(title: "Add Machine Data", style: .plain, target: self, action: #selector(addMachineData))
        addDataButton.title = "Add"
        self.navigationItem.rightBarButtonItem = addDataButton
        self.title = "Machine List"
    }
    
    func initTableView(){
        machineTableView.delegate   = viewModel
        machineTableView.dataSource = viewModel
        machineTableView.rowHeight = rowHeight
        viewModel.tableView = machineTableView
        viewModel.didSelectCell = {
            [weak self] index in
            let controller = MachineDetailVC()
            controller.machine = self?.viewModel.machinies[index]
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        viewModel.onEditButtonTap = {
            [weak self] index in
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddMachineVC") as! AddMachineVC
            controller.machine = self?.viewModel.machinies[index]
            controller.operationType = .edit
            controller.didDataSaved = {
                [weak self] in
                //refresh data with current sort state
                self?.viewModel.sortyBy = self?.viewModel.sortyBy
            }
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        viewModel.onDeleteButtonTap = {
            [weak self] index in
                self?.confirmActionDelete {
                self?.viewModel.deleteMachine(index: index)
            }
        }
    }
    
    func confirmActionDelete(callBack : @escaping(() -> Void)){
        let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure want to delete ?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            callBack()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func sortByType(_ sender: Any) {
        
        self.viewModel.sortyBy = .type
        self.sortByNameButton.alpha = 1.0
        self.sortByTypeButton.alpha = 0.2
    }
    @IBAction func sortByName(_ sender: Any) {
        
        self.viewModel.sortyBy = .name
        self.sortByNameButton.alpha = 0.2
        self.sortByTypeButton.alpha = 1.0
    }
    
    @objc func addMachineData(){
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddMachineVC") as! AddMachineVC
        controller.didDataSaved = {
            [weak self] in
            //refresh data with current sort state
            self?.viewModel.sortyBy = self?.viewModel.sortyBy
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
      
}

class MachineTableVewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    
    var onEditButtonTap : (() -> ())?
    var onDeleteButtonTap : (() -> ())?
    
    @IBAction func didEditButtonTap(_ sender: Any) {
        self.onEditButtonTap?()
        
    }
    @IBAction func didDeleteButtonTap(_ sender: Any) {
        self.onDeleteButtonTap?()
    }
}
