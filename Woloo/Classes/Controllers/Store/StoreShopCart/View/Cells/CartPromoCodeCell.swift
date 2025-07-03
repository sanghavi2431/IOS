//
//  CartPromoCodeCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

protocol CartPromoCodeCellDelegate: NSObjectProtocol{
    func didPromocodeEntered(strPromocode: String)
}

class CartPromoCodeCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtField: UITextField!
    
    weak var delegate: CartPromoCodeCellDelegate?
    
    var promocode: String? = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtField.delegate = self
        self.txtField.addTarget(self, action: #selector(self.txtFldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func txtFldDidChange(_ textField: UITextField) {
        
        self.promocode = textField.text
        

    }
    
    
    @IBAction func clickedApplyBtn(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.didPromocodeEntered(strPromocode: self.promocode ?? "")
        }
    }
    
}
