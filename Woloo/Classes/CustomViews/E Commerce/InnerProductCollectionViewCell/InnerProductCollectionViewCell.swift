//
//  InnerProductCollectionViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 04/08/21.
//

import UIKit
import SDWebImage

class InnerProductCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK:- Variables
    var product : Product? {
        didSet {
            nameLabel.text = product?.name ?? ""
            priceLabel.text = "Rs. \(Int(product?.price ?? 0.0))"
            productImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            productImage.sd_setImage(with: URL(string: product?.image ?? ""), completed: nil)
        }
    }
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "InnerProductCollectionViewCell", bundle: .main)
    }
}
