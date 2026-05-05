//
//  ProductImageCollectionViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 05/08/21.
//

import UIKit
import SDWebImage

class ProductImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    var image: String? {
        didSet {
            productImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            productImage.sd_setImage(with: URL(string: image ?? ""), completed: nil)
        }
    }
}
