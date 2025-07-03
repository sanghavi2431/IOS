//
//  EditAddressPopUpViewController.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import UIKit

protocol EditAddressPopUpViewControllerDelegate: NSObject{
    
    func didAddressUpdated()
}

class EditAddressPopUpViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldFlatNo: UITextField!
    @IBOutlet weak var txtFieldLocality: UITextField!
    @IBOutlet weak var txtFieldApartment: UITextField!
    @IBOutlet weak var txtFieldPincode: UITextField!
    @IBOutlet weak var txtFieldAddressType: UITextField!
    
    var objEditAddressSave = StoreAddress()
    var isComeFrom: String? = ""
    weak var delegate: EditAddressPopUpViewControllerDelegate?
    var objEditAddressPopUpViewModel = EditAddressPopUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }

    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: 390)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        self.objEditAddressPopUpViewModel.delegate = self
        if self.isComeFrom == "Add_Address"{
            self.lblTitle.text = "Add Address"
        }
        else{
            self.lblTitle.text = "Edit Address"
        }
        
        self.txtFieldFlatNo.delegate  = self
        self.txtFieldFlatNo.addTarget(self, action: #selector(self.txtFldFlatNoDidChange(_:)), for: .editingChanged)
        self.txtFieldPincode.keyboardType = .numberPad
        
        self.txtFieldLocality.delegate = self
        self.txtFieldLocality.addTarget(self, action: #selector(self.txtFldLocalityDidChange(_:)), for: .editingChanged)
        self.txtFieldLocality.text = self.objEditAddressSave.city ?? ""
        
        self.txtFieldApartment.delegate = self
        self.txtFieldApartment.addTarget(self, action: #selector(self.txtFldApartmentDidChange(_:)), for: .editingChanged)
        self.txtFieldApartment.text = self.objEditAddressSave.address_1 ?? ""
        
        self.txtFieldPincode.delegate = self
        self.txtFieldPincode.addTarget(self, action: #selector(self.txtFldPinCodeDidChange(_:)), for: .editingChanged)
        self.txtFieldPincode.keyboardType = .numberPad
        self.txtFieldPincode.text = self.objEditAddressSave.postal_code ?? ""
        
        self.txtFieldAddressType.delegate = self
        self.txtFieldAddressType.addTarget(self, action: #selector(self.txtFldAddressTypeDidChange(_:)), for: .editingChanged)
        
        self.txtFieldAddressType.text = self.objEditAddressSave.address_name ?? ""
        
    }
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedBtnSubmit(_ sender: Any) {
        if self.isComeFrom == "Add_Address"{
            
            self.objEditAddressPopUpViewModel.addAddressAPI(objAddress: self.objEditAddressSave)
            
        }
        else{
            self.objEditAddressPopUpViewModel.editAddressAPI(objAddress: self.objEditAddressSave)
        }
    }
    
}
