//
//  NewViewController.swift
//  Machine Gallery
//
//  Created by laluheri on 10/15/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import UIKit
import Photos

class ShowFullImage: UIViewController ,UIScrollViewDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    lazy var imageManager = PHImageManager.default()
    var image: PHAsset?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.showImage()
        })
    }
    
    func showImage(){
        if let image = image{
            PHImageManager.default().requestImage(for: image, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) {
                image, info in
                self.imageView.image = image
            }
        }
    }
}

