//
//  BenifitsCell.swift
//  Woloo
//
//  Created by ideveloper2 on 09/06/21.
//

import UIKit

class BenifitsCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }
    
    func setupCell() {
        let bulletPointsArray = ["Drive customers to your outlet by being a part of the Woloo network.", "Grow your business with repeated flow of customers.", "Enhance the value of your brand as a socially responsible entity.", "Earn points every time a Woloo customer scans the QR code given in the washroom. Redeem these points for purchases on the Woloo ecommerce platform."]
        let convertToBulletString = BulletPoints.shared.add(bulletList: bulletPointsArray, font: UIFont(name: "OpenSans-Bold", size: 12.0) ?? .systemFont(ofSize: 12.0),textColor: .black, bulletColor: .black)
        self.descriptionLabel.attributedText = convertToBulletString
    }

}
