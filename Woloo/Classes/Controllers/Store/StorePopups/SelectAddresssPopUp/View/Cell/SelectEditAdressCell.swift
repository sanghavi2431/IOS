//
//  SelectEditAdressCell.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import UIKit

protocol SelectEditAdressCellDelegate: NSObjectProtocol{
    
    func didClickedOnEditAdress(objAddress: StoreAddress?)
    
    func didClickedOnDeleteAddress(objAddress: StoreAddress?)
    
    func didClickedRadioBtn(objAddress: StoreAddress?)
}

class SelectEditAdressCell: UITableViewCell {

    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblTitleAddress: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var objAddress = StoreAddress()
    weak var delegate: SelectEditAdressCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureSelectEditAdressCell(objAddress: StoreAddress?){
        self.objAddress = objAddress ?? StoreAddress()
        
        if objAddress?.isSelected == true{
            self.btnRadio.isSelected = true
        }
        else{
            self.btnRadio.isSelected = false
        }
        
        self.lblTitleAddress.text = self.objAddress.address_name ?? ""
        self.lblAddress.text = "\(self.objAddress.address_1 ?? "")\(self.objAddress.address_2 ?? ""),\(self.objAddress.city ?? ""),\(self.objAddress.province ?? "")\(self.objAddress.postal_code ?? "")"
        
    }
    
    @IBAction func clickedBtnRadio(_ sender: UIButton) {
        self.btnRadio.isSelected = !self.btnRadio.isSelected
        
        if self.btnRadio.isSelected == true{
            self.objAddress.isSelected = true
        }
        else{
            self.btnRadio.isSelected = false    
        }
        
        if self.delegate != nil {
            self.delegate?.didClickedRadioBtn(objAddress: self.objAddress)
        }
    }
    
    @IBAction func clickedBtnEditAddress(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didClickedOnEditAdress(objAddress: self.objAddress)
        }
        
    }
    
    @IBAction func clickedDeleteBtn(_ sender: UIButton) {
        if self.delegate != nil{
            
            self.delegate?.didClickedOnDeleteAddress(objAddress: self.objAddress)
        }
        
    }
    
    
    
}
