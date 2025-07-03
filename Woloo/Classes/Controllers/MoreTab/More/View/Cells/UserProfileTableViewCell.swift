//
//  UserProfileTableViewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 24/10/24.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var vwBackMembership: ShadowView!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var wolooPointLbl: UILabel!
    @IBOutlet weak var wolooPremimumLbl: UILabel!
    
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnOpenImagePicker: UIButton!
    @IBOutlet weak var btnOpenMyAccount: UIButton!
    
    var editProfileClickEvent: (() -> Void)?
    var editProfilePicClickEvent: (() -> Void)?
    var openAccountClickEvent: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let width = bgView.frame.size.width
        let height = bgView.frame.size.height

        if width < height{
            self.bgView.cornerRadius = width / 5.7
        }
        else{
            self.bgView.cornerRadius = height / 5.7
        }
        
         // Bold
        self.nameLbl.font = UIFont(name: "CenturyGothic-Bold", size: 16) // Bold
        self.wolooPremimumLbl.font = UIFont(name: "CenturyGothic-Bold", size: 16)
        self.wolooPointLbl.font = UIFont(name: "CenturyGothic-Bold", size: 16)
        
    }
    
    func updateProfileImage(image: UIImage) {
           profileImageView.image = image
       }

    func configureUserProfileTableViewCell(objUser: MoreTabDetailV2?){
      
        let name = objUser?.userData?.name?.capitalized ?? ""
        self.nameLbl.text = name.isEmpty ? "Guest" : name
        
        // mobile
        let mobileNumber = String(objUser?.userData?.mobile ?? 0)
       

        if let avtar = objUser?.userData?.avatar, avtar.count > 0 {
            let url = "\(objUser?.userData?.baseUrl ?? "")\(avtar)"
            print("profile img url: ", url)
            self.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "user_default"))
            //            self.profileImageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            self.profileImageView.image = UIImage(named: "user_default")
        }
        
        // point & subscription
        self.wolooPointLbl.text = "\(objUser?.userCoin?.total_coins ?? 0) Woloo Points"
        
        if let expiryDatestr = objUser?.userData?.expiry_date  {
            let expiryDate = expiryDatestr.toDate(format: "yyyy-MM-dd")
            var dayComponent    = DateComponents()
            dayComponent.day    = 0
             let theCalendar     = Calendar.current
            let e2        = theCalendar.date(byAdding: dayComponent, to: expiryDate)
            let days = e2?.intervalBetweenDates(ofComponent: .day, fromDate: Date()) ?? 0
            if days < 0 {
                    self.wolooPremimumLbl.text = "Membership Expired"
            } else {
                if objUser?.subscriptionData?.name?.count ?? 0 > 0 {
                    self.wolooPremimumLbl.text = objUser?.subscriptionData?.name?.uppercased()
                }
                else if Utility.isEmpty(objUser?.subscriptionData?.name ?? ""){
                    self.wolooPremimumLbl.text = "FREE TRIAL"
                }
            }
        }
    }
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        editProfileClickEvent?()
    }
    @IBAction func editProfilePicButtonAction(_ sender: Any) {
        editProfilePicClickEvent?()
    }
    
    
    @IBAction func clickedOpenMyAccount(_ sender: UIButton) {
        openAccountClickEvent?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
