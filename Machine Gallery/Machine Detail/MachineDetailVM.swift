//
//  MachineDetailVM.swift
//  Machine Gallery
//
//  Created by laluheri on 10/17/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import Foundation
import UIKit
import Photos
class MachineDetailVM: NSObject{
    
    weak var collectionView : UICollectionView!
    let imageSize = CGSize(width: 50, height: 50)
    
    
    var service : MachineService
    
    var machine: Machine!{
        didSet{
            self.comvertPathToPAsset()
        }
    }
    var didSelectItem: ((PHAsset) -> Void)?
    
    var phAssets = [PHAsset]()
    
    
    init(service: MachineService) {
        self.service = service
    }
    
    func comvertPathToPAsset(){
        for image in machine.images{
            self.phAsset(string: image.path)
        }
    }
    
    func phAsset(string: String){
        let assetUrl = URL(string: "assets-library://asset/asset.HEIC?id="+string+"&ext=HEIC")!
        // retrieve the list of matching results for your asset url
        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
        if let photo = fetchResult.firstObject {
            self.phAssets.append(photo)
        }
        else {
            //delete path if image not found in gallery
            self.service.deleteImage(path: string)
        }
    }
    
}

extension MachineDetailVM: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.phAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCollectionCell
            cell.machineId.text = machine.id
            cell.machineName.text = machine.name
            cell.machineType.text = machine.type
            cell.qrCode.text = machine.qrcode
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            if let lastMaintenance = machine.lastMaintenance{
                cell.lastMaintenance.text = formatter.string(from: lastMaintenance)
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
            let asset = self.phAssets[indexPath.row]
            PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: nil) {
                image, info in
                cell.image.image = image
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            
            return CGSize(width: collectionView.bounds.width, height: 340)
        }
        else {
            return imageSize
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1{
            self.didSelectItem?(self.phAssets[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0{
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
        else {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    
}
