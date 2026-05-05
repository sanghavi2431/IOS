//
//  BannerCollectionCell.swift
//  Woloo
//
//  Created on 29/07/21.
//

import UIKit

class BannerCollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerDescLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillInfo(title: String, description: String, image: UIImage) {
        titleLabel.text = title
        bannerDescLabel.text = description
        locationImageView.image = image
        locationImageView.setImageColor(color: UIColor.white)
    }
}
