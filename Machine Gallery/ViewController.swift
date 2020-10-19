//
//  ViewController.swift
//  Machine Gallery
//
//  Created by laluheri on 10/15/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func ontap(_ sender: Any) {
        //push to dashboard
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MachineListVc") as! MachineListVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func scanQRCode(_ sender: Any) {
        
        self.navigationController?.pushViewController(ScanQRVC(), animated: true)
    }
    
}

