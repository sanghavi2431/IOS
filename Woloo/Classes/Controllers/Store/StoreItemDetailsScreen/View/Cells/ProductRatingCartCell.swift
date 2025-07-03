//
//  ProductRatingCartCell.swift
//  Woloo
//
//  Created by CEPL on 05/03/25.
//

import UIKit

protocol ProductRatingCartCellDelegate: NSObjectProtocol{
    
    func didUpdateProductQuantity(objproduct: Products?, strType: String?)
}

class ProductRatingCartCell: UITableViewCell {
    
    @IBOutlet weak var lblQuantity: UILabel!
    
    var objProduct = Products()
    var delegate: ProductRatingCartCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureProductRatingCartCell(objProducts: Products?){
        self.objProduct = objProducts ?? Products()
        
        self.lblQuantity.text = String(self.objProduct.quantity ?? 0)
    }
    
    
    @IBAction func clickedBtnAdd(_ sender: UIButton) {
        if self.delegate != nil{
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Add")
        }
    }
    
    
    @IBAction func clickedBtnRemove(_ sender: UIButton) {
        if self.delegate != nil{
            self.delegate?.didUpdateProductQuantity(objproduct: self.objProduct, strType: "Remove")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
