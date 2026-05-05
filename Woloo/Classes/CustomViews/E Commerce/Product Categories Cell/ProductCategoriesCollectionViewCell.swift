//
//  ProductCategoriesCollectionViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 28/08/21.
//

import UIKit
import SDWebImage

class ProductCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var categoriesImageView: UIImageView!
    
    var productCategories: ProductCategory? {
        didSet {
            headingLabel.text = (productCategories?.name ?? "").uppercased()
            categoriesImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            categoriesImageView.sd_setImage(with: URL(string: productCategories?.getFinalImage ?? ""), completed: nil)
        }
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "ProductCategoriesCollectionViewCell", bundle: .main)
    }
}
