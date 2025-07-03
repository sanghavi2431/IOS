//
//  OrderDetailTableCell.swift
//  Woloo
//
//  Created by CEPL on 10/04/25.
//

import UIKit

protocol OrderDetailTableCellDelegate: NSObject{
    
    func didSelectCheckStatus(objProducts: Products?, objOrder: OrderListings?)
    
    func didClickedAddRating(objProducts: Products?)
}

class OrderDetailTableCell: UITableViewCell {

    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    
    var objOrderDetail: OrderSets?
    var delegate: OrderDetailTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func configureOrderDetailTableCell(objStoreItems: OrderSets?) {
        self.objOrderDetail = objStoreItems
        self.lblOrderId.text = "Order ID: \(self.objOrderDetail?.id ?? "")"

        // 💥 Reset the height first
        var totalItemCount = 0

        if let orders = self.objOrderDetail?.orders {
            for order in orders {
                totalItemCount += order.items?.count ?? 0
            }
        }

        // ✅ Set final height
        self.tblHeight.constant = CGFloat(totalItemCount) * 185

        print("Final Item count: \(totalItemCount), Calculated height: \(self.tblHeight.constant)")

        // 🔁 Reload table data
        self.tableView.reloadData()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OrderDetailTableCell: UITableViewDelegate, UITableViewDataSource, OrderDetailProdItemCellProtocol{
    
    
    //MARK: -  OrderDetailProdItemCellProtocol
    func didClickedCheckStatus(objProducts: Products?) {
        if self.delegate != nil{
           // self.delegate?.didSelectCheckStatus(objProducts: objProducts, objOrder: self.objOrderDetail)
        }
    }
    
    func didClickedAddRating(objProducts: Products?) {
        if self.delegate != nil{
            self.delegate?.didClickedAddRating(objProducts: objProducts)
        }
    }
    
    
    //MARK: UItableView Delegate and UITableViewDataSourceMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.objOrderDetail?.orders?[section].items?.count ?? 0 // Add one extra row for status cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            var cell: OrderDetailProdItemCell? = tableView.dequeueReusableCell(withIdentifier: "OrderDetailProdItemCell") as? OrderDetailProdItemCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("OrderDetailProdItemCell", owner: self, options: nil)?.last as? OrderDetailProdItemCell
            }
            
        cell?.configureOrderDetailProdItemCell(objProducts: self.objOrderDetail?.orders?[indexPath.section].items?[indexPath.row])
            cell?.selectionStyle = .none
            return cell!
    }
}
