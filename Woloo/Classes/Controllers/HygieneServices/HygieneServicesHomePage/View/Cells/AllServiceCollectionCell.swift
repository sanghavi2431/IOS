//
//  AllServiceCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 09/07/25.
//

import UIKit

class AllServiceCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    
    var objStoreProductCategories = StoreProductCategories()
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureAllServiceCollectionCell(objStoreProductCategories: StoreProductCategories?){
        self.objStoreProductCategories = objStoreProductCategories ?? StoreProductCategories()
        
        self.lblCategoryTitle.text = self.objStoreProductCategories.name ?? ""
        
        imgCategory.sd_setImage(with: URL(string: self.objStoreProductCategories.metadata?.image ?? ""), completed: nil)
    }
}
