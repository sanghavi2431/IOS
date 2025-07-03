//
//  SearchProductTableViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 31/08/21.
//

import UIKit

class SearchProductTableViewCell: UITableViewCell {
    
    static let HEIGHT: CGFloat = 150

    @IBOutlet weak var productImageVView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var producPriceLabel: UILabel!
    
    var productImages: [ProductImages] = []
    
    var product: Product? {
        didSet {
            productNameLabel.text = product?.name ?? ""
            producPriceLabel.text = "Rs. \(Int(product?.price ?? 0.0))"
            if (product?.image ?? "").contains("https") {
                productImageVView.sd_setImage(with: URL(string: (product?.image ?? "")), completed: nil)
            } else {
                productImageVView.sd_setImage(with: URL(string: ShoppingApisEndPoint.IMAGE_URL(product?.image ?? "").getDescription), completed: nil)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "SearchProductTableViewCell", bundle: .main)
    }
}
