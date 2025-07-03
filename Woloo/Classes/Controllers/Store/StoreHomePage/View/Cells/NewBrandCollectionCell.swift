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
    
    
    var objProduct = Products()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    func configureNewBrandCollectionCell(objProducts: Products?){
        
        self.vwBack.viewCornerRadius = 18.24
        self.bgImg.layer.cornerRadius = 18.24
        
        self.objProduct = objProducts ?? Products()
        self.bgImg.sd_setImage(with: URL(string: objProducts?.thumbnail ?? ""), completed: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
