//
//  AddMachineVC.swift
//  Machine Gallery
//

import UIKit
import OpalImagePicker
import Photos

enum OperationType {
    case add
    case edit
}


class AddMachineVC: UIViewController {

    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var qrCode: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    
    var viewModel = AddMachineVM(service: MachineServiceImpl())
    
    var machine : Machine?
    var operationType : OperationType?
    var didDataSaved : (() -> ())?
    
    var datePicker :UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initOperation()
        self.initView()
        
    }
    
    func initOperation(){
        switch operationType {
        case .edit:
            self.editMachine()
        default: break
            
        }
    }
    
    deinit {
        print("deinit AddMachineVC")
    }
    
    func initView(){
        name.delegate   = self
        type.delegate   = self
        qrCode.delegate = self
        
        name.addTarget(self, action: #selector(AddMachineVC.textFieldChange(_:)), for: .editingChanged)
        type.addTarget(self, action: #selector(AddMachineVC.textFieldChange(_:)), for: .editingChanged)
        qrCode.addTarget(self, action: #selector(AddMachineVC.textFieldChange(_:)), for: .editingChanged)
  
        
        qrCode.keyboardType = .numberPad
        self.initCollectionView()
        self.addDoneButtonToKeyboard()
    }
    
    func addDoneButtonToKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        qrCode.inputAccessoryView = doneToolbar
    }
    
    func showMessage(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func initCollectionView(){
        imageCollection.delegate   = viewModel
        imageCollection.dataSource = viewModel
        viewModel.imageCollection  = imageCollection
        viewModel.didSelectItem = {
            [weak self] index in
            self?.confirmActionDelete {
                self?.viewModel.assets.remove(at: index)
            }
        }
        viewModel.onFormValidation = {
            [weak self] isValid,alpha in
            self?.buttonSave.isEnabled = isValid
            self?.buttonSave.alpha     = alpha
        }
    }

    func confirmActionDelete(callBack : @escaping(() -> Void)){
        let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure want to delete the image?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            callBack()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    func editMachine(){
        if let machine = machine{
            self.name.text = machine.name
            self.type.text = machine.type
            self.qrCode.text = machine.qrcode
            //enable button
            self.buttonSave.isEnabled = true
            self.buttonSave.alpha = 1.0
            self.viewModel.images = machine.images
        }
    }
    
    @objc func textFieldChange(_ textField: UITextField) {
        viewModel.name  = name.text
        viewModel.type  = type.text
        viewModel.qrCode = qrCode.text
    }
    
    @IBAction func showImageGallery(_ sender: Any) {
        if self.viewModel.availableSelectionsAllowed > 0{
            let imagePicker = OpalImagePickerController()
            //Only allow image media type assets
            imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
            imagePicker.maximumSelectionsAllowed = self.viewModel.availableSelectionsAllowed
            presentOpalImagePickerController(imagePicker, animated: true,
                                             select: { (assets) in
                                                
                                                for asset in assets{
                                                    if !self.viewModel.assets.contains(asset){
                                                        self.viewModel.assets.append(asset)
                                                    }
                                                }
                                                
                                                imagePicker.dismiss(animated: true, completion: nil)
            }, cancel: {
                
            })
        }
        else {
            self.showMessage(title: "", message: "You are not allowed to select more than 10 images")
        }
    }
    
    @IBAction func didSave(_ sender: Any) {
        
        switch operationType {
        case .edit:
            self.viewModel.updateMachine {
                [weak self] in
                self?.machine?.name = self?.name.text
                self?.machine?.type = self?.type.text
                self?.machine?.qrcode = self?.qrCode.text
                self?.machine?.lastMaintenance = Date().localDate()
                self?.machine?.images.removeAll()
                if let phAssetToObj = self?.viewModel.phAssetToObj(){
                    for phM in phAssetToObj{
                        self?.machine?.images.append(phM)
                    }
                }
            }
            break
        default:
            self.viewModel.addMachine()
            break
        }
        self.didDataSaved?()
        self.navigationController?.popViewController(animated: true)
    }

}

extension AddMachineVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}


class PhotoCell : UICollectionViewCell{
    @IBOutlet weak var image: UIImageView!
    
}
