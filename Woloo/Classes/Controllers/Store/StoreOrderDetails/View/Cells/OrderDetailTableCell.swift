//
//  OrderDetailTableCell.swift
//  Woloo
//
//  Created by CEPL on 10/04/25.
//

import UIKit

protocol OrderDetailTableCellDelegate: NSObject{
    
    func didSelectCheckStatus(objOrderSets: OrderSets?, objOrder: Orders?)
    
    func didClickedAddRating(objProducts: OrderItem?)
    
    func didClickedOrderID(objOrderSets: OrderSets?)
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

        // ✅ Calculate total number of items across all orders once
        let totalItemCount = self.objOrderDetail?.orders?.reduce(0, { $0 + ($1.items?.count ?? 0) }) ?? 0

        // ✅ Set correct height
        self.tblHeight.constant = CGFloat(totalItemCount) * 197

        print("Total items: \(totalItemCount), Height: \(self.tblHeight.constant)")

        self.tableView.reloadData()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnClickedOrderID(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didClickedOrderID(objOrderSets: self.objOrderDetail)
        }
        
    }
    
}

extension OrderDetailTableCell: UITableViewDelegate, UITableViewDataSource, OrderDetailProdItemCellProtocol{
   
    //MARK: -  OrderDetailProdItemCellProtocol
    func didClickedCheckStatus(objProducts: OrderItem?, at indexPath: IndexPath?) {
        guard let section = indexPath?.section else { return }
            
            let selectedOrder = self.objOrderDetail?.orders?[section]
            
            print("Clicked Order Section: \(section)")
            print("Items in selected order: \(selectedOrder?.items ?? [])")
        
        if self.delegate != nil{
            self.delegate?.didSelectCheckStatus(objOrderSets: self.objOrderDetail, objOrder: selectedOrder)
        }
        
        
        for itemName in selectedOrder?.items ?? []{
            print("item found:", itemName.title ?? "")
        }
        
       
    }
    
    func didClickedAddRating(objProducts: OrderItem?) {
        if self.delegate != nil{
            self.delegate?.didClickedAddRating(objProducts: objProducts)
        }
    }
    
    
    //MARK: UItableView Delegate and UITableViewDataSourceMethods
    func numberOfSections(in tableView: UITableView) -> Int {
        print("self.objOrderDetail?.orders?.count ?? 0", self.objOrderDetail?.orders?.count ?? 0)
        return self.objOrderDetail?.orders?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.objOrderDetail?.orders?[section].items?.count ?? 0 // Add one extra row for status cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            var cell: OrderDetailProdItemCell? = tableView.dequeueReusableCell(withIdentifier: "OrderDetailProdItemCell") as? OrderDetailProdItemCell
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("OrderDetailProdItemCell", owner: self, options: nil)?.last as? OrderDetailProdItemCell
            }
            
        cell?.delegate = self
        cell?.indexPath = indexPath
        cell?.configureOrderDetailProdItemCell(objProducts: self.objOrderDetail?.orders?[indexPath.section].items?[indexPath.row])
            cell?.selectionStyle = .none
            return cell!
    }
}
