//
//  CartPromoCodeCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

protocol CartPromoCodeCellDelegate: NSObjectProtocol{
    func didPromocodeEntered(strPromocode: String)
    func didDeletePromoCode(strPromocode: String?)
}

class CartPromoCodeCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnApply: ShadowViewButton!
    
    weak var delegate: CartPromoCodeCellDelegate?
    
    var promocode: String? = ""
    var objPromotions = Promotions()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtField.delegate = self
        self.txtField.addTarget(self, action: #selector(self.txtFldDidChange(_:)), for: .editingChanged)
    }
    
    func configureCartPromoCodeCell(objPromotion: Promotions?){
        self.objPromotions = objPromotion ?? Promotions()
        if !(Utility.isEmpty(self.objPromotions.code ?? "")) {
            self.txtField.text = self.objPromotions.code ?? ""
            self.txtField.isUserInteractionEnabled = false
            self.btnApply.setTitle("Remove", for: .normal)
            self.btnApply.setTitle("Remove", for: .highlighted)
            self.btnApply.setTitle("Remove", for: .selected)
        }else{
            self.btnApply.setTitle("Apply", for: .normal)
            self.btnApply.setTitle("Apply", for: .highlighted)
            self.btnApply.setTitle("Apply", for: .selected)
            self.txtField.isUserInteractionEnabled = true
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func txtFldDidChange(_ textField: UITextField) {
        
        self.objPromotions.code = textField.text
        

    }
    
    
    @IBAction func clickedApplyBtn(_ sender: Any) {
        
        if !(Utility.isEmpty(self.objPromotions.code ?? "")) {
            if self.delegate != nil {
                self.delegate?.didDeletePromoCode(strPromocode: self.objPromotions.code ?? "")
            }
        }
        else{
            if self.delegate != nil {
                self.delegate?.didPromocodeEntered(strPromocode: self.promocode ?? "")
            }
        }
    }
    
}
