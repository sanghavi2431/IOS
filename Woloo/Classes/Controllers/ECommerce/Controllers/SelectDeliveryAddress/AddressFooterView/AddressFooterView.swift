//
//  AddressFooterView.swift
//  Woloo
//
//  Created by Rahul Patra on 03/08/21.
//

import UIKit

class AddressFooterView: UIView {
    
    enum AddressType {
        case save
        case add
    }
    
    static let HEIGHT: CGFloat = 513

  //MARK:- Outlets
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var addAddressLabel: UILabel!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var localityTextField: UITextField!
    @IBOutlet weak var flatTextField: UITextField!
    @IBOutlet weak var landmarkTextField: UITextField!
    @IBOutlet weak var saveAddressButton: UIButton!
    
    @IBOutlet weak var addAddressFieldsStackView: UIStackView!
    
    var type: AddressType = .add {
        didSet {
            switch type {
            case .add:
                addAddressFieldsStackView.isHidden = true
                addAddressButton.isHidden = false
                
            case .save:
                addAddressFieldsStackView.isHidden = false
                addAddressButton.isHidden = true
            }
            
            getSuperController?.updateHeight(withHeght: getHeight())
        }
    }
    
    var getSuperController: SelectDeliveryAddressViewController? {
        get {
            self.iq.viewContainingController() as? SelectDeliveryAddressViewController
        }
    }
    
    override
    func layoutSubviews() {
        setViews()
    }
    
    func setViews() {
        saveAddressButton.addTarget(self, action: #selector(tappedOnSaveAddressButton), for: .touchUpInside)
        addAddressButton.addTarget(self, action: #selector(tappedOnAddAddressButton), for: .touchUpInside)
    }
    
    func getHeight() -> CGFloat {
        type == .save ? 460 : 60
    }
    
    
    @objc
    func tappedOnSaveAddressButton() {
        getSuperController?.persistance?.saveAddressApi(andPincode: pincodeTextField.text ?? "", andCity: cityTextField.text ?? "", andState: stateTextField.text ?? "", andArea: localityTextField.text ?? "", andFlatBuilding: flatTextField.text ?? "", andLandmark: landmarkTextField.text ?? "", { [weak self] isSuccess, message in
            if isSuccess {
                self?.getSuperController?.persistance?.changeStatus(.add)
                self?.getSuperController?.getDelieveryAddress()
                (self?.iq.viewContainingController() as? SelectDeliveryAddressViewController)?.updateHeight()
            } else {
                self?.getSuperController?.showToast(message: message)
            }
        })
    }
    
    @objc
    func tappedOnAddAddressButton() {
        
    }
    
    class func loadNib() -> AddressFooterView? {
        UINib(nibName: "AddressFooterView", bundle: .main).instantiate(withOwner: self, options: nil).first as? AddressFooterView
    }
}
