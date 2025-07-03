//
//  PeriodEssentialsCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 07/03/25.
//

import UIKit

class PeriodEssentialsCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topicTitleLabel: UILabel!
    
    @IBOutlet weak var topicImageView: UIImageView!
    
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
        
        self.bgView.layer.cornerRadius = self.bgView.frame.height/2
        self.bgView.clipsToBounds = true
    }
    
    
    func configureShopCell(objStoreProductCategories: StoreProductCategories?){
        self.objStoreProductCategories = objStoreProductCategories ?? StoreProductCategories()
        
        self.topicTitleLabel.text = self.objStoreProductCategories.name ?? ""
        self.bgView.backgroundColor = UIColor(hexString: self.objStoreProductCategories.metadata?.background_color ?? "C7E3F9")
        topicImageView.sd_setImage(with: URL(string: self.objStoreProductCategories.metadata?.image ?? ""), completed: nil)
       
    }
  
}
