//
//  EditAddressPopUpViewController.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import UIKit

protocol EditAddressPopUpViewControllerDelegate: NSObject{
    
    func didAddressUpdated()
    
    func didSearchAdressFromaAddAddress()
}

class EditAddressPopUpViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldFlatNo: UITextField!
    @IBOutlet weak var txtFieldLocality: UITextField!
    @IBOutlet weak var txtFieldApartment: UITextField!
    @IBOutlet weak var txtFieldPincode: UITextField!
    @IBOutlet weak var txtFieldAddressType: UITextField!
    @IBOutlet weak var btnChooseYourLocation: UIButton!
    
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldCity: UITextField!
    @IBOutlet weak var txtFieldState: UITextField!
    @IBOutlet weak var txtFieldPhoneNo: UITextField!
    
    
    var objEditAddressSave = StoreAddress()
    var isComeFrom: String? = ""
    weak var delegate: EditAddressPopUpViewControllerDelegate?
    var objEditAddressPopUpViewModel = EditAddressPopUpViewModel()
    
    var strBuildingName: String? = ""
    var strLocality: String? = ""
    var strCity: String? = ""
    var strState: String? = ""
    var strPincode: String? = ""
    var strFullAddress: String? = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }

    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.64)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        self.objEditAddressPopUpViewModel.delegate = self
        self.btnChooseYourLocation.layer.cornerRadius = 5.0
        if self.isComeFrom == "Add_Address"{
            self.lblTitle.text = "Add Address"
        }
        else{
            self.lblTitle.text = "Edit Address"
        }
        
        self.txtFieldFlatNo.delegate  = self
        self.txtFieldFlatNo.addTarget(self, action: #selector(self.txtFldFlatNoDidChange(_:)), for: .editingChanged)
        
        
        self.txtFieldLocality.delegate = self
        self.txtFieldLocality.addTarget(self, action: #selector(self.txtFldLocalityDidChange(_:)), for: .editingChanged)
        self.txtFieldLocality.text = self.objEditAddressSave.locality ?? ""
        
        self.txtFieldApartment.delegate = self
        self.txtFieldApartment.addTarget(self, action: #selector(self.txtFldApartmentDidChange(_:)), for: .editingChanged)
        self.txtFieldApartment.text = self.objEditAddressSave.address_1 ?? ""
        
        self.txtFieldPincode.delegate = self
        self.txtFieldPincode.addTarget(self, action: #selector(self.txtFldPinCodeDidChange(_:)), for: .editingChanged)
        self.txtFieldPincode.keyboardType = .numberPad
        self.txtFieldPincode.text = self.objEditAddressSave.postal_code ?? ""
        
        
        self.txtFieldAddressType.text = self.objEditAddressSave.address_name ?? ""
        self.txtFieldAddressType.delegate = self
        self.txtFieldAddressType.addTarget(self, action: #selector(self.txtFldAddressTypeDidChange(_:)), for: .editingChanged)
        
        
        self.txtFieldCity.text = self.objEditAddressSave.city ?? ""
        
        
        self.txtFieldState.text = self.objEditAddressSave.province ?? ""
        
        
        
        self.txtFieldFlatNo.text = self.objEditAddressSave.flatName ?? ""
        
        self.txtFieldFirstName.delegate = self
        self.txtFieldFirstName.text = self.objEditAddressSave.first_name ?? ""
        self.txtFieldFirstName.addTarget(self, action: #selector(self.txtFldFirstNameDidChange(_:)), for: .editingChanged)
        
        self.txtFieldLastName.delegate = self
        self.txtFieldLastName.text = self.objEditAddressSave.last_name ?? ""
        self.txtFieldLastName.addTarget(self, action: #selector(self.txtFldLastNameDidChange(_:)), for: .editingChanged)
        
        self.txtFieldCity.delegate = self
        self.txtFieldCity.addTarget(self, action: #selector(self.txtFldCityDidChange(_:)), for: .editingChanged)
        
        self.txtFieldState.delegate = self
        self.txtFieldState.addTarget(self, action: #selector(self.txtFldStateDidChange(_:)), for: .editingChanged)
        
        self.txtFieldPhoneNo.delegate = self
        self.txtFieldPhoneNo.text = self.objEditAddressSave.phone ?? ""
        self.txtFieldPhoneNo.addTarget(self, action: #selector(self.txtFldPhomeDidChange(_:)), for: .editingChanged)
        
    }
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    
    @IBAction func didClickedBackBtn(_ sender: Any) {
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
    
    @IBAction func clickedChooseYourLocation(_ sender: UIButton) {
        //showToast(message:"Unable to fetch your current location")
        if self.delegate != nil{
            self.delegate?.didSearchAdressFromaAddAddress()
            self.dismiss(animated: true)
        }
    }
}
