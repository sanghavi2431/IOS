//
//  AllProductsCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 07/03/25.
//

import UIKit

protocol AllProductsCollectionCellDelegate: NSObjectProtocol{
    
    func didClickedBackBtn()
}

class AllProductsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    
    weak var delegate: AllProductsCollectionCellDelegate?
    
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
    
    @IBAction func clickedBackBtn(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickedBackBtn()
        }
        
    }
}
