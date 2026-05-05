//
//  StoreBlankHeaderCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 07/03/25.
//

import UIKit

class StoreBlankHeaderCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
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
