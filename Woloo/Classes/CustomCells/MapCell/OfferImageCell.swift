//
//  OfferImageCell.swift
//  Woloo
//
//  Created by Ashish Khobragade on 14/01/21.
//

import UIKit

class OfferImageCell: UICollectionViewCell {

    @IBOutlet weak var offerImage: UIImageView!
    
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
