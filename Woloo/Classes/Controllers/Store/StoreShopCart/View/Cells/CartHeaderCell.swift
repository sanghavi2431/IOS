//
//  CartHeaderCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

class CartHeaderCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCartHeaderCell(){
        
        self.imgView.image = UIImage(named: "icon_shopping_Cart")
        self.lblTitle.text = "Cart"
        self.lblDescription.text = "Checkout you purchases from here"
        
    }
    
    func configureStoreOrderHeaderCell(){
        
        self.imgView.image = UIImage(named: "icon_store_Order")
        self.lblTitle.text = "Order Details"
        self.lblDescription.text = "Check or modiify the details of your order here"
        
    }
    //icon_order_list
    //check your recent order here
    func configureStoreOrderHeaderListCell(){
        self.imgView.image = UIImage(named: "icon_order_list")
        self.lblTitle.text = "Order"
        self.lblDescription.text = "check your recent order here"
    }
    
}
