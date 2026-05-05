//
//  ProductOptionCell.swift
//  Woloo
//
//  Created by CEPL on 24/06/25.
//

import UIKit

class ProductOptionCell: UICollectionViewCell {

    @IBOutlet weak var lblOptionName: UILabel!
    @IBOutlet weak var vwBack: ShadowView!
    
    var objVariantValues = ProductOptionValue()
    var strOption: SizeOption?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    func configureProductOptionCell(objProductOptionValue: ProductOptionValue?){
        self.objVariantValues = objProductOptionValue ?? ProductOptionValue()
        
        self.lblOptionName.text = self.objVariantValues.value ?? ""
        
        if self.objVariantValues.isSelected == true
        {
            self.vwBack.backgroundColor = UIColor(named: "Woloo_Yellow")
        }
        else{
            self.vwBack.backgroundColor = UIColor.white
        }
    }
    
    func configureProductOptionsFilterCell(strOption: SizeOption?){
        self.strOption = strOption
        self.lblOptionName.text = strOption?.value
        
        self.vwBack.backgroundColor = strOption?.isSelected == true ? UIColor(named: "Woloo_Yellow") : UIColor.white
    }
    

}
