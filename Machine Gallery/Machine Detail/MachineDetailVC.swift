//
//  MachineDetailVC.swift
//  Machine Gallery
//
//  Created by laluheri on 10/17/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import UIKit

class MachineDetailVC: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = MachineDetailVM(service: MachineServiceImpl())
    
    var machine: Machine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.machine = machine

        collectionView.register(UINib(nibName: "DetailCollectionCell", bundle: nil), forCellWithReuseIdentifier: "detailCell")
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        collectionView.delegate   = viewModel
        collectionView.dataSource = viewModel

        viewModel.didSelectItem = {
            [weak self]image in
            //push to dashboard
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImage") as! ShowFullImage
            controller.image = image
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    deinit {
        print("deinit MachineDetailVC")
    }
}
