//
//  MoreTabVcProfileCell.swift
//  Woloo
//
//  Created by Vivek shinde on 21/12/20.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var mobileno: UILabel!
    @IBOutlet weak var wolooPointLbl: UILabel!
    @IBOutlet weak var wolooPremimumLbl: UILabel!
    var editProfileClickEvent: (() -> Void)?
    var editProfilePicClickEvent: (() -> Void)?
    var handlePrimiumClickEvent: (() -> Void)?
    
    func configureUI(_ data: MoreTabDetail?)  {
        //        self.profileImageView.sd_setImage(with: URL(string: UserModel.user?.profilePicUrl ?? "")) { (img, error, _, _) in
        //            if error != nil {
        //                self.profileImageView.setImage(string: kUserPlaceholderURL)
        //            }
        //        }
        // name
        let name = UserModel.user?.name?.capitalized ?? ""
        self.nameLbl.text = name.isEmpty ? "Guest" : name
        
        // mobile
        let mobileNumber = UserModel.user?.mobile ?? ""
        self.mobileno.text = mobileNumber.isEmpty ? "" : mobileNumber
//      let email = UserModel.user?.email ?? ""
//      let phone = UserModel.user?.mobile ?? ""
//      self.mobileno.text = email.isEmpty ? phone : email
        
        // gender
        let gender = UserDefaultsManager.fetchUserData()?.profile?.gender ?? ""
        self.locationLbl.text = gender.isEmpty ? "Female" : gender

        if let avtar = UserDefaultsManager.fetchUserData()?.profile?.avatar, avtar.count > 0 {
            let url = "\(UserDefaultsManager.fetchUserData()?.profile?.baseUrl ?? "")\(avtar)"
            self.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "user_default"))
            //            self.profileImageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            self.profileImageView.sd_setImage(with: URL(string: kUserPlaceholderURL), completed: nil)
        }
        
        // point & subscription
        self.wolooPointLbl.text = "\(data?.userCoin?.totalCoins ?? 0)"
        
        if let expiryDatestr = UserDefaultsManager.fetchUserData()?.profile?.expiry_date {
            let expiryDate = expiryDatestr.toDate(format: "yyyy-MM-dd")
            var dayComponent    = DateComponents()
            dayComponent.day    = 1
             let theCalendar     = Calendar.current
            let e2        = theCalendar.date(byAdding: dayComponent, to: expiryDate)
            let days = e2?.intervalBetweenDates(ofComponent: .day, fromDate: Date()) ?? 0
            if days < 0 {
                    self.wolooPremimumLbl.text = "Membership Expired"
            } else {
                if data?.subscriptionData?.name?.count ?? 0 > 0 {
                    self.wolooPremimumLbl.text = data?.subscriptionData?.name?.uppercased()
                } else if data != nil {
                    self.wolooPremimumLbl.text = "Membership Expired"
                }
            }
        }

        tapGestureOnPremium()
    }
    
    func configureUIV2(_ data: MoreTabDetailV2?)  {
        //        self.profileImageView.sd_setImage(with: URL(string: UserModel.user?.profilePicUrl ?? "")) { (img, error, _, _) in
        //            if error != nil {
        //                self.profileImageView.setImage(string: kUserPlaceholderURL)
        //            }
        //        }
        // name
        //let name = UserModel.user?.name?.capitalized ?? ""
        
        let name = data?.userData?.name?.capitalized ?? ""
        self.nameLbl.text = name.isEmpty ? "Guest" : name
        
        // mobile
        let mobileNumber = String(data?.userData?.mobile ?? 0)
        self.mobileno.text = mobileNumber.isEmpty ? "" : mobileNumber
//      let email = UserModel.user?.email ?? ""
//      let phone = UserModel.user?.mobile ?? ""
//      self.mobileno.text = email.isEmpty ? phone : email
        
        // gender
        let gender = data?.userData?.gender ?? ""
        self.locationLbl.text = gender.isEmpty ? "Female" : gender

        if let avtar = data?.userData?.avatar, avtar.count > 0 {
            let url = "\(data?.userData?.baseUrl ?? "")\(avtar)"
            self.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "user_default"))
            //            self.profileImageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            self.profileImageView.sd_setImage(with: URL(string: kUserPlaceholderURL), completed: nil)
        }
        
        // point & subscription
        self.wolooPointLbl.text = "\(data?.userCoin?.total_coins ?? 0)"
        
        if let expiryDatestr = data?.userData?.expiry_date  {
            let expiryDate = expiryDatestr.toDate(format: "yyyy-MM-dd")
            var dayComponent    = DateComponents()
            dayComponent.day    = 0
             let theCalendar     = Calendar.current
            let e2        = theCalendar.date(byAdding: dayComponent, to: expiryDate)
            let days = e2?.intervalBetweenDates(ofComponent: .day, fromDate: Date()) ?? 0
            if days < 0 {
                    self.wolooPremimumLbl.text = "Membership Expired"
            } else {
                if data?.subscriptionData?.name?.count ?? 0 > 0 {
                    self.wolooPremimumLbl.text = data?.subscriptionData?.name?.uppercased()
                } 
                else if Utility.isEmpty(data?.subscriptionData?.name ?? ""){
                    self.wolooPremimumLbl.text = "FREE TRIAL"
                }
            }
        }

        tapGestureOnPremium()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - @IBActions
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        editProfileClickEvent?()
    }
    @IBAction func editProfilePicButtonAction(_ sender: Any) {
        editProfilePicClickEvent?()
    }
    
    @objc func premiumClickEvent() {
        self.handlePrimiumClickEvent?()
    }
}

// MARK: - Utility
extension ProfileCell {
    func tapGestureOnPremium() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(premiumClickEvent))
        tap.numberOfTapsRequired = 1
        wolooPremimumLbl.isUserInteractionEnabled = true
        wolooPremimumLbl.addGestureRecognizer(tap)
    }
}
