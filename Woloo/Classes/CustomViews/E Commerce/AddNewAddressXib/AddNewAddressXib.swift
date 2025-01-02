//
//  AddNewAddressXib.swift
//  Woloo
//
//  Created by Rahul Patra on 08/08/21.
//

import UIKit

class AddNewAddressXib: UIView {

    @IBOutlet weak var addButton: UIButton!
    
    class func loadNib() -> AddNewAddressXib? {
        UINib(nibName: "AddNewAddressXib", bundle: .main).instantiate(withOwner: self, options: nil).first as? AddNewAddressXib
    }
}
