//
//  ProductItemInfoCell.swift
//  Woloo
//
//  Created by CEPL on 05/03/25.
//

import UIKit

protocol ProductItemInfoCellDelegate: NSObjectProtocol{
    func didClickedBuyNowBtn(objProduct: Products?)
        
}

class ProductItemInfoCell: UITableViewCell {

    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblSellerName: UILabel!
  //  @IBOutlet weak var lblProductPrice: UILabel!
    
    var objProduct = Products()
    weak var delegate: ProductItemInfoCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureProductItemInfoCell(objProduct: Products?){
        
        self.objProduct = objProduct ?? Products()
        self.lblSellerName.text = self.objProduct.collection?.title ?? ""
        self.lblProductTitle.text = self.objProduct.title ?? ""
        //self.lblProductPrice.text = "\u{20B9}" + "\(self.objProduct.variants?[0].calculated_price?.original_amount ?? 0)"
        
        
    }
    
    
//    @IBAction func clickedBtnBuyNow(_ sender: UIButton) {
//        print("self.objProduct.quantity: detail ", self.objProduct.quantity)
//        if self.objProduct.quantity ?? 0 == 0{
//            Global.showAlert(title: "", message: "Please Add Product")
//        }
//        else{
//            if self.delegate != nil{
//                self.delegate?.didClickedBuyNowBtn(objProduct: self.objProduct)
//            }
//        }
//        
//      
//    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
