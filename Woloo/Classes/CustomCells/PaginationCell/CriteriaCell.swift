//
//  CriteriaCell.swift
//  Woloo
//
//  Created by ideveloper2 on 09/06/21.
//

import UIKit

class CriteriaCell: UICollectionViewCell {

    var handleInterestedAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func criteriaAction(_ sender: Any) {
        handleInterestedAction?()
    }
    
}
