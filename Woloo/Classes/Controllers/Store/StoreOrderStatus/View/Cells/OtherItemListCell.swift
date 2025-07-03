//
//  OtherItemListCell.swift
//  Woloo
//
//  Created by CEPL on 12/05/25.
//

import UIKit

class OtherItemListCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var lblAmt: UILabel!
    @IBOutlet weak var vwBack: UIView!
    
    var objProducts = Products()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureOrderDetailProdItemCell(objProducts: Products?){
        
        self.vwBack.layer.cornerRadius = 5.26
        self.imgView.layer.cornerRadius = 12.1
        self.objProducts = objProducts ?? Products()
        self.imgView.sd_setImage(with: URL(string: self.objProducts.thumbnail ?? ""), completed: nil)
        
        self.lblAmt.text = "Rs. \(self.objProducts.unit_price ?? 0)"
        
        self.lblProdName.text = self.objProducts.subtitle ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
