//
//  FilterCatCollectionViewCell.swift
//  Woloo
//
//  Created by CEPL on 17/04/25.
//

import UIKit

class FilterCatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var vwBack: ShadowView!
    
    
    var objCategories = StoreProductCategories()
    
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
    
    func configureFilterCatViews(objCategories: StoreProductCategories?){
        
        self.objCategories = objCategories ?? StoreProductCategories()
        print("cat name: \(self.objCategories.name ?? "")")
        self.filterLabel.text = self.objCategories.name
        
        self.vwBack.backgroundColor = self.objCategories.isSelected ?? false ? UIColor(named: "Woloo_Yellow") : UIColor.white
    }
}
