//
//  DistannceBottomCollectionViewCell.swift
//  Woloo
//
//  Created by CEPL on 29/08/25.
//

import UIKit

class DistannceBottomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var distanceTxtLbl: UILabel!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
