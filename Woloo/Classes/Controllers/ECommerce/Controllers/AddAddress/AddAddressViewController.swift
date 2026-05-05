//
//  AddAddressViewController.swift
//  Woloo
//
//  Created by Rahul Patra on 02/08/21.
//

import UIKit

class AddAddressViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var localityTextField: UITextField!
    @IBOutlet weak var flatNoTextField: UITextField!
    @IBOutlet weak var landmarkTextField: UITextField!
    @IBOutlet weak var saveAddressButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    
    var persistance: AddAddressPersistance? = AddAddressPersistance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        saveAddressButton.addTarget(self, action: #selector(taSaveAddressButton), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(tapCartButton), for: .touchUpInside)
    }
    
    //MARK:- Custom functions
    func saveAddresss() {
        persistance?.saveAddressApi(andPincode: pincodeTextField.text ?? "", andCity: cityTextField.text ?? "", andState: stateTextField.text ?? "", andArea: localityTextField.text ?? "", andFlatBuilding: flatNoTextField.text ?? "", andLandmark: landmarkTextField.text ?? "", { [weak self] isSuccess, message in
            if isSuccess {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.showToast(message: message)
            }
        })
    }
    
    //MARK:- Action
    @objc
    func tapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func taSaveAddressButton(_ sender: UIButton) {
        saveAddresss()
    }
    
    @objc
    func tapCartButton(_ sender: UIButton) {
        
    }
}
