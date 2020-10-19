//
//  ScanQRVC.swift
//  Machine Gallery
//
//  Created by laluheri on 10/17/20.
//  Copyright © 2020 hazard. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRVC: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{
    
    var captureSession: AVCaptureSession!
    @IBOutlet weak var containerView: UIView!
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    let service = MachineServiceImpl()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = self.view.frame
        previewLayer?.videoGravity = .resizeAspectFill
        guard let previewLayer = previewLayer else { return }
        
        containerView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        previewLayer?.frame = view.frame
        previewLayer?.videoGravity = .resizeAspectFill
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        let result = self.service.findMachine(qrCode: code)
        if let result = result{
            let controller = MachineDetailVC()
            controller.machine = result
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            self.showMessage(title: "Not Found", message: "QrCode Not Found")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func showMessage(title: String,message: String){
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
           
           self.present(alert, animated: true, completion: nil)
       }

}
