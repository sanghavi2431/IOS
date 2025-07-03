//
//  OrderStatusCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 08/03/25.
//

import UIKit

class OrderStatusCollectionCell: UICollectionViewCell {

    @IBOutlet weak var vwLeft: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var vwRight: UIView!
    @IBOutlet weak var lblOrderPlaced: UILabel!

    
    var currIndexPath: IndexPath?
    var objOrderListings = OrderSets()
    
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
    
    func configureOrderStatusCollectionCell(indexPath: IndexPath, objOrderListings: OrderSets?){
        /*
         not_fulfilled (Order Placed)
          fulfilled (Order Accepted)
          shipped (Order Shipped)
          delivered (Order delivered)
         */
        self.objOrderListings = objOrderListings ?? OrderSets()
        
        self.currIndexPath = indexPath
        
        print("self.objOrderListings.fulfillment_status", self.objOrderListings.fulfillment_status ?? "")
        
        switch indexPath.item{
            //icon_uncheck
            //icon_check
        case 0:
            self.lblOrderPlaced.text = "Order Placed"
            self.vwLeft.isHidden = true
            self.imgView.image = UIImage(named: "icon_check")
            
        case 1:
            self.lblOrderPlaced.text = "Order Acepted"
            if self.objOrderListings.fulfillment_status == "fulfilled" || self.objOrderListings.fulfillment_status == "shipped" || self.objOrderListings.fulfillment_status == "delivered"{
                self.imgView.image = UIImage(named: "icon_check")
            }
            else{
                self.imgView.image = UIImage(named: "icon_uncheck")
            }
            
            
        case 2:
            self.lblOrderPlaced.text = "Order Shipped"
           // self.imgView.image = UIImage(named: "icon_uncheck")
            if self.objOrderListings.fulfillment_status == "shipped" || self.objOrderListings.fulfillment_status == "delivered"{
                self.imgView.image = UIImage(named: "icon_check")
            }
            else{
                self.imgView.image = UIImage(named: "icon_uncheck")
            }
            
            
            
        case 3:
            self.lblOrderPlaced.text = "Order Delivered"
            if self.objOrderListings.fulfillment_status == "delivered"{
                self.imgView.image = UIImage(named: "icon_check")
            }
            else{
                self.imgView.image = UIImage(named: "icon_uncheck")
            }
            self.vwRight.isHidden = true
        default:
            break
            
        }
    }

}
