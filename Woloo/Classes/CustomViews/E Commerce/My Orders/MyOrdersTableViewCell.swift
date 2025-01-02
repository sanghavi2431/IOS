//
//  MyOrdersTableViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 01/09/21.
//

import UIKit

class MyOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var amountQtyLabel: UILabel!
    @IBOutlet weak var amountPointLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var returnOrderButton: UIButton!
    
    var myOrder: MyOrder? {
        didSet {
            orderIdLabel.text = "Order Id: \(myOrder?.orderID ?? "")"
            dateLabel.text = myOrder?.dateTime ?? ""
            amountPointLabel.text = "Amount: \(myOrder?.amount ?? "")"
            orderStatusLabel.text = "Order Status: \(myOrder?.status ?? "")"
            productNameLabel.text = myOrder?.name ?? ""
            amountQtyLabel.text = "Rs. \(myOrder?.price ?? "") x \(myOrder?.qty ?? "")"
            
            if (myOrder?.image ?? "").contains("http") {
                productImage.sd_setImage(with: URL(string: myOrder?.image ?? ""), placeholderImage: UIImage(named: ""))
            } else {
                productImage.sd_setImage(with: URL(string: ShoppingApisEndPoint.IMAGE_URL(myOrder?.image ?? "").getDescription), placeholderImage: UIImage(named: ""))
            }
            
            if myOrder?.canReturn ?? "0" == "1" {
                returnOrderButton.isHidden = false
            } else {
                returnOrderButton.isHidden = true
            }
            
            returnOrderButton.addTarget(self, action: #selector(tappedOnReturnOrderButton), for: .touchUpInside)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "MyOrdersTableViewCell", bundle: .main)
    }
    
    
    @objc
    func tappedOnReturnOrderButton() {
        (self.iq.viewContainingController() as? MyOrdersViewController)?.returnOrder(withOrder: myOrder)
    }
}
