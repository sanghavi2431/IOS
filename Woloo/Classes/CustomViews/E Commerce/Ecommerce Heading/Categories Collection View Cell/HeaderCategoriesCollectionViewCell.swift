//
//  HeaderCategoriesCollectionViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 02/08/21.
//

import UIKit
import SDWebImage

class HeaderCategoriesCollectionViewCell: UICollectionViewCell {
    
    //MARK:- outlets
    @IBOutlet weak var mainIconImageView: UIImageView!
    @IBOutlet weak var topheadingLabel: UILabel!
    @IBOutlet weak var bottomHeadingLabel: UILabel!
    
    //MARK:- variables
    var category: HomeCategory? {
        didSet {
            mainIconImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            mainIconImageView.sd_setImage(with: URL(string: ShoppingApisEndPoint.IMAGE_URL(category?.image ?? "").getDescription), completed: nil)
            bottomHeadingLabel.text = (category?.name ?? "").uppercased()
        }
    }
    
    var product: ProductCategory? {
        didSet {
            mainIconImageView.sd_setImage(with: URL(string: product?.getFinalImage ?? ""), completed: nil)
            bottomHeadingLabel.text = (product?.name ?? "").uppercased()
        }
    }
    
    //MARK:- view hirarchy
    override
    func awakeFromNib() {
        setViews()
    }
    
    //MARK:- custom functions
    func setViews() {
//        mainIconImageView.layer.cornerRadius = 30
//        mainIconImageView.layer.borderWidth = 1
//        mainIconImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "HeaderCategoriesCollectionViewCell", bundle: .main)
    }
}
