//
//  AddMachineVM.swift
//  Machine Gallery
//
//  Created by laluheri on 10/16/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import Foundation
import UIKit
import Photos
import RealmSwift

class AddMachineVM: NSObject{
    
    var service : MachineService

    weak var imageCollection : UICollectionView?
    
    let maximumSelectionsAllowed = 10
    var availableSelectionsAllowed: Int{
        return maximumSelectionsAllowed - self.assets.count
    }
    let imageSize = CGSize(width: 100, height: 100)
    var didSelectItem : ((Int) -> Void)?
    var onFormValidation: ((Bool,CGFloat) -> Void)?
    
    var images : List<Image>?{
        didSet{
            if let images = images{
                for image in images{
                    self.phAsset(string: image.path)
                }
            }
        }
    }
    
    var assets:[PHAsset]{
        didSet{
            self.imageCollection?.reloadData()
        }
    }
    
    //name TextField binding
    var name: String?{
        didSet{
            self.validateForm()
        }
    }
    //type TextField binding
    var type: String?{
        didSet{
            self.validateForm()
        }
    }
    //qrCode TextField binding
    var qrCode: String?{
        didSet{
            self.validateForm()
        }
    }
    
    init(service: MachineService) {
        
        self.service = service
        self.assets = [PHAsset]()
    }
    
    func validateForm(){
        if name != "" && qrCode != "" && type != ""{
            self.onFormValidation?(true,1.0)
        }
        else {
            self.onFormValidation?(false,0.3)
        }
    }
    
    func updateMachine(updateCallback: (()->())){
        self.service.updateMachine {
            updateCallback()
        }
    }
    
    func addMachine(){
        let machine = Machine()
        machine.name = name!
        machine.type = type!
        machine.qrcode = qrCode!
        machine.id = String.randomString(length: 10)
        //insert last maintenance date
        machine.lastMaintenance = Date().localDate()
        machine.images = self.phAssetToObj()
        
        self.service.addMachine(machine: machine)
    }
    
    func phAssetToObj() -> List<Image>{
        let images = List<Image>()
        for asset in assets{
            let originalName = PHAssetResource.assetResources(for: asset)
            let fileName = (originalName.first?.assetLocalIdentifier.getFileName())
            let image = Image()
            image.id = String.randomString(length: 100)
            image.path = fileName!
            images.append(image)
        }
        return images
    }
    
    func phAsset(string: String){
        let assetUrl = URL(string: "assets-library://asset/asset.HEIC?id="+string+"&ext=HEIC")!
        // retrieve the list of matching results for your asset url
        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
        if let photo = fetchResult.firstObject {
            self.assets.append(photo)
        }
        else {
            //delete path if image not found in gallery
            self.service.deleteImage(path: string)
        }
    }
    
}

extension AddMachineVM : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! PhotoCell
        
        let asset = self.assets[indexPath.row]
        
        PHImageManager.default().requestImage(for: asset, targetSize: self.imageSize, contentMode: .aspectFit, options: nil) {
            image, info in
            cell.image.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItem?(indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.imageSize
    }
    

    
}


extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}
