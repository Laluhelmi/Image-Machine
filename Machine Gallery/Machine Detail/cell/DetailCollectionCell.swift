//
//  DetailCollectionCell.swift
//  Machine Gallery
//
//  Created by laluheri on 10/17/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import UIKit

class DetailCollectionCell: UICollectionViewCell {

    @IBOutlet weak var machineId: UILabel!
    @IBOutlet weak var machineName: UILabel!
    @IBOutlet weak var qrCode: UILabel!
    @IBOutlet weak var machineType: UILabel!
    @IBOutlet weak var lastMaintenance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
