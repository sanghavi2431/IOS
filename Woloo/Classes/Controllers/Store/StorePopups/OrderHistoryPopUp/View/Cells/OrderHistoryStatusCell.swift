//
//  OrderHistoryStatusCell.swift
//  Woloo
//
//  Created by CEPL on 02/07/25.
//

import UIKit

class OrderHistoryStatusCell: UITableViewCell {

    @IBOutlet weak var lblOrderPlacedDate: UILabel!
    @IBOutlet weak var lblOrderDeliveredDate: UILabel!
    @IBOutlet weak var lblOrderFullFillStatus: UILabel!
    
    var objOrderSets = OrderSets()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureOrderHistoryStatusCell(objOrderSets: OrderSets?){
        self.objOrderSets = objOrderSets ?? OrderSets()
        

        let formattedDate = convertDateFormat(inputDate: self.objOrderSets.created_at ?? "")
        print(formattedDate)
        self.lblOrderPlacedDate.text = formattedDate
        
        
        let formattedDeliveryDate = convertDateFormat(inputDate: self.objOrderSets.delivery_date ?? "")
        print(formattedDate)
        self.lblOrderDeliveredDate.text = formattedDeliveryDate
        
        
        
        if self.objOrderSets.fulfillment_status == "fulfilled"{
            self.lblOrderFullFillStatus.text = "Order Acepted"
            
        }
        if self.objOrderSets.fulfillment_status == "not_fulfilled"{
            self.lblOrderFullFillStatus.text = "Pending"
        }
        else if self.objOrderSets.fulfillment_status == "shipped"{
            self.lblOrderFullFillStatus.text = "Order Shipped"
        }
        else if self.objOrderSets.fulfillment_status == "delivered"{
            self.lblOrderFullFillStatus.text = "Order Delivered"
            
        }
            
        
        
        
    }
    
}

func convertDateFormat(inputDate: String) -> String {
    let inputFormatter = ISO8601DateFormatter()
    inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    if let date = inputFormatter.date(from: inputDate) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone.current
        return outputFormatter.string(from: date)
    } else {
        print("❌ Failed to parse ISO8601 date")
        return ""
    }
}

