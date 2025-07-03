//
//  ProductCollectionViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 02/08/21.
//

import UIKit
import SDWebImage

class ProductCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    //MARK:- Variables
    var product: Product? {
        didSet {
            productImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            if (product?.image ?? "").contains("http") {
                productImage.sd_setImage(with: URL(string: product?.image ?? ""), completed: nil)
            } else {
                productImage.sd_setImage(with: URL(string: ShoppingApisEndPoint.IMAGE_URL(product?.image ?? "").getDescription), completed: nil)
            }
            
            productNameLabel.text = (product?.name ?? "").uppercased()
            productNameLabel.numberOfLines = 3
            
        }
    }
    
    //MARK:- Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK:- Static function
    class func loadNib() -> UINib? {
        UINib(nibName: "ProductCollectionViewCell", bundle: .main)
    }
}
