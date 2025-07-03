//
//  ShopCategoryCell.swift
//  Woloo
//
//  Created by Ashish Khobragade on 28/12/20.
//

import UIKit

class ShopCategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
