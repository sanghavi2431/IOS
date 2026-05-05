//
//  NewBrandCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

class NewBrandCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var bgImg: UIImageView!
    
    
    @IBOutlet weak var vwBack: ShadowView!
    
    
    var objProduct = StoreProductCategories()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    func configureNewBrandCollectionCell(objProducts: StoreProductCategories?){
        
        self.vwBack.viewCornerRadius = 18.24
        self.bgImg.layer.cornerRadius = 18.24
        
        self.objProduct = objProducts ?? StoreProductCategories()
        
        bgImg.sd_setImage(with: URL(string: self.objProduct.metadata?.image ?? ""), completed: nil)
    }
    
    func configureExpressBooking(){
        self.bgImg.image = UIImage(named: "bg_express_booking")
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
