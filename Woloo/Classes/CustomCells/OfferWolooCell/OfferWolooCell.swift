//
//  OfferWolooCell.swift
//  Woloo
//
//  Created on 26/08/21.
//

import UIKit

class OfferWolooCell: UICollectionViewCell {

    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var offerTitleLabel: UILabel!
    @IBOutlet weak var offerDescriptionlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = offerDescriptionlabel.text
    }
    
    func setInfo(_ info: WolooOffer) {
            // set label Attribute
        offerTitleLabel.text = info.offerDescription
        offerDescriptionlabel.text = info.couponCode
//        offerImageView.setImageColor(color: UIColor.white)
//        offerImageView.sd_setImage(with: URL(string: info.image ?? ""), completed: nil)
    }
}
