//
//  StoreRecentSearchCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 28/06/25.
//

import UIKit

class StoreRecentSearchCollectionCell: UICollectionViewCell {

    @IBOutlet weak var searchlbl: UILabel!
    
    var objSearch = Products()
    
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

    func configureStoreRecentSearchCollectionCell(objSearch: Products?){
        
        self.objSearch = objSearch ?? Products()
        self.searchlbl.text = self.objSearch.title ?? ""
    }
    
}
