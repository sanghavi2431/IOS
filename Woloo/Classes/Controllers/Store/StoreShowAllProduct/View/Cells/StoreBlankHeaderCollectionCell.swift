//
//  StoreBlankHeaderCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 07/03/25.
//

import UIKit

class StoreBlankHeaderCollectionCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
