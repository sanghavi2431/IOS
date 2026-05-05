//
//  OrderDetailProdItemCell.swift
//  Woloo
//
//  Created by CEPL on 10/04/25.
//

import UIKit

protocol OrderDetailProdItemCellProtocol: NSObjectProtocol{
    
    func didClickedCheckStatus(objProducts: OrderItem?, at indexPath: IndexPath?)
    
    func didClickedAddRating(objProducts: OrderItem?)
}

class OrderDetailProdItemCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var lblAmt: UILabel!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lbDefaultVariant: UILabel!
    @IBOutlet weak var vwBackConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwBackLeadingConstraint: NSLayoutConstraint!
    
    
    var indexPath: IndexPath?
    var objProducts = OrderItem()
    var delegate: OrderDetailProdItemCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureOrderDetailProdItemCell(objProducts: OrderItem?){
        
        self.vwBack.layer.cornerRadius = 5.26
        self.imgView.layer.cornerRadius = 12.1
        self.objProducts = objProducts ?? OrderItem()
        self.imgView.sd_setImage(with: URL(string: self.objProducts.thumbnail ?? ""), completed: nil)
        
        self.lbDefaultVariant.text = self.objProducts.title ?? ""
        self.lblAmt.text = String(format: "%@%.2f/-","\u{20B9}",self.objProducts.unit_price ?? 0.0)
        
        self.lblProdName.text = self.objProducts.subtitle ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedBtnCheckStatus(_ sender: UIButton) {
        if self.delegate != nil{
            self.delegate?.didClickedCheckStatus(objProducts: self.objProducts, at: self.indexPath)
        }
        
      
    }
    
    @IBAction func clickedAddRatingBtn(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didClickedAddRating(objProducts: self.objProducts)
        }
    }
    
}
