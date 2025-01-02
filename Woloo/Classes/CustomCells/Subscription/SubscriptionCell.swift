//
//  SubscriptionCell.swift
//  Woloo
//
//  Created by Vivek shinde on 21/12/20.
//

import UIKit
import CoreGraphics

class SubscriptionCell: UITableViewCell {
    
    
    @IBOutlet weak var lblBuyNow: UILabel!
    @IBOutlet weak var lblMonthly: UILabel!
    @IBOutlet weak var leftLineImageView: UIImageView!
    @IBOutlet weak var rightLineImageView: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var subscriptionTypeView: UIView!
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    //    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var htmlTextVw: UITextView!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var strikeLblTxt: UILabel!
    //    @IBOutlet weak var btnUpgrade: UIButton!
    @IBOutlet weak var lblActive: UIButton!
    //    @IBOutlet weak var voucherView: UIView!
    //    @IBOutlet weak var lblVoucherName: UILabel!
    //    @IBOutlet weak var lblCorporationName: UILabel!
    //    @IBOutlet weak var triangleView: TriangleView!
    
//    var upgradeBlock: (() -> Void)? = nil
    //    var popUpViewHandler: (() -> Void)? = nil
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //    func configureUI(_ bgColorStr : String , subscriptionBgColorStr : String)  {
    //        var shieldColor = Global.shared.hexStringToUIColor(hex: "FFF896")
    //        var bgColor = Global.shared.hexStringToUIColor(hex: "FFFFFF")
    //        if bgColorStr.contains("#") && bgColorStr.count > 6 {
    //            bgColor = Global.shared.hexStringToUIColor(hex: bgColorStr)
    //        }
    //        if subscriptionBgColorStr.contains("#") && subscriptionBgColorStr.count > 6 {
    //            shieldColor = Global.shared.hexStringToUIColor(hex: subscriptionBgColorStr)
    //        }
    //        self.bgView.backgroundColor = bgColor
    //        self.subscriptionTypeView.backgroundColor = shieldColor
    //        triangleView.giveColor(color: shieldColor)
    //    }
    
    func setData(subscriptionData: WolooPlanModel) {
        //        voucherView.isHidden = true
        //        lblName.text = subscriptionData.name
        
        let annualSubs = "annual"
        
        let daysCheck = String(subscriptionData.days ?? 0)
        if  subscriptionData.frequency?.lowercased() == annualSubs {
            print("365")
            strikeLblTxt.textColor = UIColor.init(hexString: "#f4e17d")
            lblUserName.textColor = UIColor.init(hexString: "#f4e17d")
            lblPrice.textColor = UIColor.init(hexString: "#f4e17d")
            lblFrequency.textColor = UIColor.init(hexString: "#f4e17d")
            clubNameLabel.textColor = UIColor.init(hexString: "#f4e17d")
            lblStartDate.textColor = UIColor.init(hexString: "#f4e17d")
            lblEndDate.textColor = UIColor.init(hexString: "#f4e17d")
            lblMonthly.textColor = UIColor.init(hexString: "#f4e17d")
            lblMonthly.text = "\(subscriptionData.frequency?.uppercased() ?? "") GOLD MEMBERSHIP"
            cardImageView.image = UIImage(named: "gold_card");
            leftLineImageView.image = UIImage(named: "gold_line");
            rightLineImageView.image = UIImage(named: "gold_line");
            logoImage.setImageColor(color: UIColor.init(hexString: "#f4e17d") ?? UIColor.white)
        } else {
            print("30")
            strikeLblTxt.textColor = UIColor.white
            lblUserName.textColor = UIColor.white
            lblPrice.textColor = UIColor.white
            lblFrequency.textColor = UIColor.white
            lblFrequency.textColor = UIColor.white
            lblStartDate.textColor = UIColor.white
            lblEndDate.textColor = UIColor.white
            lblMonthly.textColor = UIColor.white
            lblMonthly.text = "\(subscriptionData.frequency?.uppercased() ?? "") SILVER MEMBERSHIP"
            cardImageView.image = UIImage(named: "silver_card");
            leftLineImageView.image = UIImage(named: "silver_line");
            rightLineImageView.image = UIImage(named: "silver_line");
            logoImage.setImageColor(color: UIColor.white)
        }

        let name = UserModel.user?.name?.capitalized ?? ""
        lblUserName.text = name.isEmpty ? "Guest" : name.uppercased()
        let currency = subscriptionData.currency ?? ""
        print("number of days : \(subscriptionData.days)")
        if currency == "INR" {
            let rupee = "\u{20B9}"
            lblPrice.text = "\(rupee) \(subscriptionData.price ?? "")"
        } else {
            lblPrice.text = "\(subscriptionData.currency ?? "") \(subscriptionData.price ?? "")"
        }
        if subscriptionData.strikeOutPrice != nil{
            let rupee = "\u{20B9}"
            let attributedText = NSAttributedString(
                string: "\(rupee)\(subscriptionData.strikeOutPrice!)",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            strikeLblTxt.attributedText = attributedText
//            strikeLblTxt.isHidden = false
            //strikeLblTxt.text = "\(subscriptionData.strikeOutPrice!)"
            
        }
        else{
            strikeLblTxt.isHidden = true
        }
//        if let name = subscriptionData.name{
//            lblMonthly.text = "\(name ?? "")"
//        }
        if let freq = subscriptionData.frequency {
            lblFrequency.text = "\(freq)".uppercased()
            
        }
        if subscriptionData.name?.lowercased() == "free trial" {
            lblFrequency.isHidden = true
        } else {
            lblFrequency.isHidden = false
        }
                
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = subscriptionData.days
        if let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let fdate = dateFormatter.string(from: futureDate)
            //            lblStartDate.text = "Starts on \(dateFormatter.string(from: Date()))\nEnds on \(fdate)"
            lblStartDate.text = "START DATE : \(dateFormatter.string(from: Date()))\nEnds on \(fdate)".uppercased()
            if subscriptionData.endAt == nil{
                print("end date is coming nill show future date in my subscription")
                lblEndDate.text = "END DATE : \(fdate)".uppercased()
            }else{
                print("end date is coming from api show in get ")
                lblEndDate.text = "END DATE: \(subscriptionData.endAt ?? "")"
            }
            //lblEndDate.text = "END DATE : \(fdate)".uppercased()
            //lblEndDate.text = "END DATE: \(subscriptionData.endAt ?? "")"
        }
        
        if let desc = subscriptionData.wdescription {
            DispatchQueue.main.async {
                let htmlData = NSString(string: desc).data(using: String.Encoding.utf8.rawValue)
                let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                if let data = htmlData {
                    let attributedString = try? NSAttributedString(data: data,
                                                                   options: options,
                                                                   documentAttributes: nil)
                    self.htmlTextVw.attributedText = attributedString
                }
            }
        }
        //        if subscriptionData.isVoucher == 1 {
        //            voucherView.isHidden = false
        //            lblVoucherName.text = subscriptionData.name
        //            lblCorporationName.text = subscriptionData.corporationName
        //        }
    }
    
    func setDataV2(subscriptionDataV2: GetPlanModel){
        
        let annualSubs = "annual"
        
        let daysCheck = String(subscriptionDataV2.days ?? 0)
        if  subscriptionDataV2.frequency?.lowercased() == annualSubs {
            print("365")
            strikeLblTxt.textColor = UIColor.init(hexString: "#f4e17d")
            lblUserName.textColor = UIColor.init(hexString: "#f4e17d")
            lblPrice.textColor = UIColor.init(hexString: "#f4e17d")
            lblFrequency.textColor = UIColor.init(hexString: "#f4e17d")
            clubNameLabel.textColor = UIColor.init(hexString: "#f4e17d")
            lblStartDate.textColor = UIColor.init(hexString: "#f4e17d")
            lblEndDate.textColor = UIColor.init(hexString: "#f4e17d")
            lblMonthly.textColor = UIColor.init(hexString: "#f4e17d")
            lblMonthly.text = "\(subscriptionDataV2.frequency?.uppercased() ?? "") GOLD MEMBERSHIP"
            cardImageView.image = UIImage(named: "gold_card");
            leftLineImageView.image = UIImage(named: "gold_line");
            rightLineImageView.image = UIImage(named: "gold_line");
            logoImage.setImageColor(color: UIColor.init(hexString: "#f4e17d") ?? UIColor.white)
        } else {
            print("30")
            strikeLblTxt.textColor = UIColor.white
            lblUserName.textColor = UIColor.white
            lblPrice.textColor = UIColor.white
            lblFrequency.textColor = UIColor.white
            lblFrequency.textColor = UIColor.white
            lblStartDate.textColor = UIColor.white
            lblEndDate.textColor = UIColor.white
            lblMonthly.textColor = UIColor.white
            lblMonthly.text = "\(subscriptionDataV2.frequency?.uppercased() ?? "") SILVER MEMBERSHIP"
            cardImageView.image = UIImage(named: "silver_card");
            leftLineImageView.image = UIImage(named: "silver_line");
            rightLineImageView.image = UIImage(named: "silver_line");
            logoImage.setImageColor(color: UIColor.white)
        }

        let name = UserModel.user?.name?.capitalized ?? ""
        lblUserName.text = name.isEmpty ? "Guest" : name.uppercased()
        let currency = subscriptionDataV2.currency ?? ""
        print("number of days : \(subscriptionDataV2.days)")
        if currency == "INR" {
            let rupee = "\u{20B9}"
            lblPrice.text = "\(rupee) \(subscriptionDataV2.price ?? "")"
        } else {
            lblPrice.text = "\(subscriptionDataV2.currency ?? "") \(subscriptionDataV2.price ?? "")"
        }
        if subscriptionDataV2.strike_out_price != nil{
            let rupee = "\u{20B9}"
            let attributedText = NSAttributedString(
                string: "\(rupee)\(subscriptionDataV2.strike_out_price!)",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            strikeLblTxt.attributedText = attributedText
//            strikeLblTxt.isHidden = false
            //strikeLblTxt.text = "\(subscriptionData.strikeOutPrice!)"
            
        }
        else{
            strikeLblTxt.isHidden = true
        }
//        if let name = subscriptionData.name{
//            lblMonthly.text = "\(name ?? "")"
//        }
        if let freq = subscriptionDataV2.frequency {
            lblFrequency.text = "\(freq)".uppercased()
            
        }
        if subscriptionDataV2.name?.lowercased() == "free trial" {
            lblFrequency.isHidden = true
        } else {
            lblFrequency.isHidden = false
        }
                
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = subscriptionDataV2.days
        if let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let fdate = dateFormatter.string(from: futureDate)
            
            // lblStartDate.text = "START DATE : \(subscriptionDataV2.start_at ?? "")\nEnds on \(subscriptionDataV2.end_at ?? "")".uppercased()
            if subscriptionDataV2.start_at == nil{
                lblStartDate.text = "Starts on \(dateFormatter.string(from: Date()))\nEnds on \(fdate)"
            }
            else{
                lblStartDate.text = "START DATE : \(subscriptionDataV2.start_at ?? "")\nEnds on \(subscriptionDataV2.end_at ?? "")".uppercased()
            }
            
            if subscriptionDataV2.end_at == nil{
                print("end date is coming nill show future date in my subscription")
                lblEndDate.text = "END DATE : \(fdate)".uppercased()

                //lblEndDate.text = "END DATE : \(subscriptionDataV2.end_at ?? "")".uppercased()
            }else{
                print("end date is coming from api show in get ")
                lblEndDate.text = "END DATE: \(subscriptionDataV2.end_at ?? "")"
            }
            //lblEndDate.text = "END DATE : \(fdate)".uppercased()
            //lblEndDate.text = "END D` ``ATE: \(subscriptionData.endAt ?? "")"
        }
        
        if let desc = subscriptionDataV2.description {
            DispatchQueue.main.async {
                let htmlData = NSString(string: desc).data(using: String.Encoding.utf8.rawValue)
                let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                if let data = htmlData {
                    let attributedString = try? NSAttributedString(data: data,
                                                                   options: options,
                                                                   documentAttributes: nil)
                    self.htmlTextVw.attributedText = attributedString
                }
            }
        }
        
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        subscriptionTypeView.roundCorners(corners: [.topLeft , .topRight], radius: 10)
    }
    //    @IBAction func popUpViewAction(_ sender: Any) {
    //        popUpViewHandler?()
    //    }
//    @IBAction func upgradeAction(_ sender: Any) {
//        upgradeBlock?()
//    }
}



