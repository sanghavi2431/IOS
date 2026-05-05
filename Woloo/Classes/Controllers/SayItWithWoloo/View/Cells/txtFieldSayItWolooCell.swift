//
//  txtFieldSayItWolooCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import UIKit

protocol txtFieldSayItWolooCellDelegate: NSObjectProtocol{
    func didChangedRecieverName(objAddMessageModel: AddMessageModel?)
    func didChangedPhoneNumber(objAddMessageModel: AddMessageModel?)
    func didClickSelectContactInfo()
    
}

class txtFieldSayItWolooCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var vwBackTxtField: UIView!
    @IBOutlet weak var btnOpenContact: UIButton!
    @IBOutlet weak var imgContact: UIImageView!
    
    var delegate: txtFieldSayItWolooCellDelegate?
    var objAddMessageModel = AddMessageModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBackTxtField.layer.cornerRadius = 10.0
        self.txtField.delegate = self
        self.txtField.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureReceiverNameTxtField(obj: AddMessageModel?){
        self.btnOpenContact.isHidden = true
        self.imgContact.isHidden = true
        self.txtField.addTarget(self, action: #selector(textDidChangedName(_:)), for: .editingChanged)
        
        if Utility.isEmpty(obj?.RecNumber ?? ""){
            self.txtField.placeholder = "Receiver’s Name*"
        }
        else{
            self.txtField.text = obj?.RecName ?? ""
        }
    }
    
    
    func configureReceiversContactNumber(obj: AddMessageModel?){
        self.btnOpenContact.isHidden = false
        self.imgContact.isHidden = false
        self.txtField.keyboardType = .numberPad
        self.txtField.addTarget(self, action: #selector(textDidChangedPhoneNumber(_:)), for: .editingChanged)
        if Utility.isEmpty(obj?.RecNumber ?? ""){
            self.txtField.placeholder = "Receiver’s Phone Number*"
        }
        else{
            self.txtField.text = obj?.RecNumber ?? ""
        }
    }
    
    @objc func textDidChangedPhoneNumber(_ textField: UITextField) {
       
            self.objAddMessageModel.RecNumber = textField.text
    
        if (self.delegate != nil){
            self.delegate?.didChangedPhoneNumber(objAddMessageModel: self.objAddMessageModel)
        }
    }
    
    @objc func textDidChangedName(_ textField: UITextField) {
       
            self.objAddMessageModel.RecName = textField.text

        if (self.delegate != nil){
            self.delegate?.didChangedRecieverName(objAddMessageModel: self.objAddMessageModel)
        }
    }
    
    @IBAction func clickedBtnContact(_ sender: UIButton) {
        print("open contact info")
        if (self.delegate != nil){
            self.delegate?.didClickSelectContactInfo()
        }
    }
    
}
