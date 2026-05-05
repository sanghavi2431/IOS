//
//  UserProfileTableViewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 24/10/24.
//

import UIKit

protocol UserProfileTableViewCellDelegate: NSObjectProtocol {
    
    func didTapSubStatus()
}

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
    
    weak var delegate: UserProfileTableViewCellDelegate?
    
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

    func configureUserProfileTableViewCell(objUser: UserProfileModel?){
      
        let name = objUser?.profile?.name?.capitalized ?? ""
        self.nameLbl.text = name.isEmpty ? "Guest" : name
        
        // mobile
        let mobileNumber = String(objUser?.profile?.mobile ?? 0)
       

        if let avtar = objUser?.profile?.avatar, avtar.count > 0 {
            let url = "\(objUser?.profile?.baseUrl ?? "")\(avtar)"
            print("profile img url: ", url)
            self.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "user_default"))
            //            self.profileImageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            self.profileImageView.image = UIImage(named: "user_default")
        }
        
        // point & subscription
        self.wolooPointLbl.text = "\(objUser?.totalCoins?.total_coins ?? 0) Woloo Points"
        
        
        if let expiryDatestr = objUser?.profile?.expiry_date,
           let expiryDate = expiryDatestr.toDateSubscription(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
            
            print("Expiry Date: \(expiryDate)")
            
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let expiryDay = calendar.startOfDay(for: expiryDate)
            
            // Number of days left
            let days = calendar.dateComponents([.day], from: today, to: expiryDay).day ?? 0
            print("Number of days: set user\(days)")
            
            if days < 0 {
            self.vwBackMembership.backgroundColor = UIColor.systemPink.withAlphaComponent(0.3)
                self.wolooPremimumLbl.text = "Membership Expired"
            }
            else  if days > 0 && Utility.isEmpty(objUser?.planData?.name ?? ""){
                self.wolooPremimumLbl.text = "Free Trial"
            }
            else{
                self.wolooPremimumLbl.text = objUser?.planData?.name ?? ""
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
    
    
    @IBAction func clickedBtnSubStatus(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didTapSubStatus()
        }
    }
    
}
