//
//  MySubscriptionTableCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 24/11/24.
//

import UIKit

class MySubscriptionTableCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
   // @IBOutlet weak var htmlTextVw: UILabel!
    @IBOutlet weak var lblMonthly: UILabel!
    
    @IBOutlet weak var vwBackCardView: CardShadowView!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var btnRenewNow: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.vwBackCardView.layer.cornerRadius = 23
        //self.vwBack.layer.borderWidth = 1
       // self.vwBack.layer.borderColor = UIColor(named: "yellow_button_color")?.cgColor
        self.lblPrice.font = UIFont(name: "CenturyGothic-Bold", size: 40)
        self.lblMonthly.font = UIFont(name: "CenturyGothic-Bold", size: 24)
        self.btnBuyNow.layer.cornerRadius = 5.0
        self.btnRenewNow.layer.cornerRadius = 5.0
        
    }
    
    
    func configureMySubscriptionTableCell(objSubscriptiondate: GetPlanModel,  isPlan: Bool?){
        
//        let daysCheck = String(objSubscriptiondate.days ?? 0)
//        let annualSubs = "annual"
//        
//        if  objSubscriptiondate.frequency?.lowercased() == annualSubs {
//            print("365")
//            self.lblMonthly.text = "ANNUAL"
//        }
//        else{
//            print("30")
//            self.lblMonthly.text = "MONTHLY"
//        }
        
       
        
        
        if objSubscriptiondate.is_active == true {
            self.btnRenewNow.setTitle( "ACTIVE", for: .normal)
            self.btnRenewNow.setTitle( "ACTIVE", for: .selected)
            self.btnBuyNow.backgroundColor = UIColor.lightGray
        }
        else if objSubscriptiondate.is_future == true{
            self.btnRenewNow.setTitle( "FUTURE", for: .normal)
            self.btnRenewNow.setTitle( "FUTURE", for: .selected)
            self.btnBuyNow.backgroundColor = UIColor.lightGray
        }
        else{
            self.btnRenewNow.setTitle( "Renew Now", for: .normal)
            self.btnRenewNow.setTitle( "Renew Now", for: .selected)
        }
        
        self.lblMonthly.text = objSubscriptiondate.frequency?.uppercased()
        
    
        // Safely handle hex color strings with fallback for invalid values
        self.vwBackCardView.backgroundColor = UIColor(hexString: objSubscriptiondate.backgroud_color ?? "#23231F") ?? UIColor(hexString: "#23231F") ?? UIColor.darkGray
        self.lblPrice.textColor = UIColor(hexString: objSubscriptiondate.text_color ?? "#FFFFFF") ?? UIColor(hexString: "#FFFFFF") ?? UIColor.white
        self.lblStartDate.textColor = UIColor(hexString: objSubscriptiondate.text_color ?? "#FFFFFF") ?? UIColor(hexString: "#FFFFFF") ?? UIColor.white
        self.lblEndDate.textColor = UIColor(hexString: objSubscriptiondate.text_color ?? "#FFFFFF") ?? UIColor(hexString: "#FFFFFF") ?? UIColor.white
        
        let currency = objSubscriptiondate.currency ?? ""
        
        if currency == "INR" {
            let rupee = "\u{20B9}"
            lblPrice.text = "\(rupee)\(objSubscriptiondate.price ?? "")"
        } else {
            lblPrice.text = "\(objSubscriptiondate.currency ?? "") \(objSubscriptiondate.price ?? "")"
        }
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = objSubscriptiondate.days
        if let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let fdate = dateFormatter.string(from: futureDate)
            
            // lblStartDate.text = "START DATE : \(subscriptionDataV2.start_at ?? "")\nEnds on \(subscriptionDataV2.end_at ?? "")".uppercased()
            if objSubscriptiondate.start_at == nil{
                lblStartDate.text = "START DATE: \(dateFormatter.string(from: Date()))\nEnds on \(fdate)"
            }
            else{
                lblStartDate.text = "START DATE: \(objSubscriptiondate.start_at ?? "")\nEnds on \(objSubscriptiondate.end_at ?? "")".uppercased()
            }
            
            if objSubscriptiondate.end_at == nil{
                print("end date is coming nill show future date in my subscription")
                lblEndDate.text = "END DATE: \(fdate)".uppercased()

                //lblEndDate.text = "END DATE : \(subscriptionDataV2.end_at ?? "")".uppercased()
            }else{
                print("end date is coming from api show in get ")
                lblEndDate.text = "END DATE: \(objSubscriptiondate.end_at ?? "")"
            }
            
        }
        
        if let desc = objSubscriptiondate.description {
            DispatchQueue.main.async {
                let htmlData = NSString(string: desc).data(using: String.Encoding.utf8.rawValue)
                let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                if let data = htmlData {
                    let attributedString = try? NSAttributedString(data: data,
                                                                   options: options,
                                                                   documentAttributes: nil)
                    //self.htmlTextVw.attributedText = attributedString
                }
            }
        }
        
        if isPlan ?? false{
  
            self.btnBuyNow.backgroundColor = UIColor.clear
            self.btnBuyNow.setTitle("", for: .normal)
            self.btnBuyNow.setTitle("", for: .selected)
        }
        
    }
    
    @IBAction func clickedBtnBuyNow(_ sender: Any) {
        print("call the buy delegate")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
