//
//  ProductItemDescCell.swift
//  Woloo
//
//  Created by CEPL on 05/03/25.
//

import UIKit

class ProductItemDescCell: UITableViewCell {

    var objProduct = Products()
    
    @IBOutlet weak var lblDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureProductItemDescCell(objProduct: Products?){
        self.objProduct = objProduct ?? Products()
        self.lblDescription.text = self.objProduct.description ?? "-"
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
