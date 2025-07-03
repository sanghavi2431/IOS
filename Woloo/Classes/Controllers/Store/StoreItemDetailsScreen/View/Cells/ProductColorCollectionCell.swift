//
//  ProductColorCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 05/03/25.
//

import UIKit

class ProductColorCollectionCell: UICollectionViewCell {

    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblVariantName: UILabel!
    @IBOutlet weak var lblVariantValues: UILabel!
    @IBOutlet weak var vwbackVariant: UIView!
    @IBOutlet weak var imgCheckMark: UIImageView!
    
    var objVariantValues = ProductOptionValue()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBack.layer.cornerRadius = 18.0
        self.vwBack.clipsToBounds = true
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    func configureProductColorCollectionCell(objProductOptionValue: ProductOptionValue?){
        self.objVariantValues = objProductOptionValue ?? ProductOptionValue()
        
       let hexColor = "#\(self.objVariantValues.value ?? "D3D3D3")"
        self.vwbackVariant.backgroundColor = UIColorFromHex(hexColor)
        self.lblVariantName.text = self.objVariantValues.value ?? ""
        
        if self.objVariantValues.isSelected == true
        {
            self.imgCheckMark.isHidden = false
        }
        else{
            self.imgCheckMark.isHidden = true
        }
        self.lblVariantValues.text = "Rs. 100"
    }
    
    func configureProductCollectionCell(objProductOptionValue: ProductOptionValue?){
        self.objVariantValues = objProductOptionValue ?? ProductOptionValue()
     
        self.vwbackVariant.backgroundColor = UIColorFromHex("#D3D3D3")
        self.lblVariantName.text = self.objVariantValues.value ?? ""
        self.lblVariantValues.text = "Rs. 100"
        if self.objVariantValues.isSelected == true
        {
            self.imgCheckMark.isHidden = false
        }
        else{
            self.imgCheckMark.isHidden = true
        }
    }
    
    func configureProductColorCollectionCell(strColor: String?){
//        self.lblText.isHidden = true
//        self.vwBack.backgroundColor = UIColor(hexString: strColor ?? "")
    }
    
    func configureProductSizeCollectionCell(strText: String?){
        
        self.vwBack.backgroundColor = UIColor.white
        
//        self.lblText.isHidden = false
//        self.lblText.text = strText
    }

}
