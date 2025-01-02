//
//  HistoryCell.swift
//  Woloo
//
//  Created by ideveloper2 on 10/06/21.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var distanceLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var toilet: UIImageView!
    @IBOutlet weak var wheelChair: UIImageView!
    @IBOutlet weak var feeding: UIImageView!
    @IBOutlet weak var senitizer: UIImageView!
    @IBOutlet weak var coffee: UIImageView!
    @IBOutlet weak var makeup: UIImageView!
    @IBOutlet weak var diaper: UIImageView!
    @IBOutlet weak var covidFree: UIImageView!
    @IBOutlet weak var safeSpace: UIImageView!
    @IBOutlet weak var clean: UIImageView!
    @IBOutlet weak var imgTravelMode: UIImageView!
    @IBOutlet weak var premiumLabel: UILabel!
    
    @IBOutlet weak var lblEarnedPoints: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    
    var rateThisPlaceHandler: ((_ sender: Int?) -> Void)?
//    var wolooHistory: WolooHistory?
//    var wolooStore: WolooStore?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupCell() {
        borderView.layer.cornerRadius = 20.0
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.warmGrey.cgColor
        self.premiumLabel.layer.cornerRadius = 20.0
        self.premiumLabel.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.premiumLabel.clipsToBounds = true
    }
    
}

// MARK: - @IBAction
extension HistoryCell {
    @IBAction func rateThisPlaceAction(_ sender: UIButton) {
        rateThisPlaceHandler?(sender.tag)
    }
}

// MARK: - Logics
extension HistoryCell {
    func fillHistoryDetail(_ history: History) {
        let detail = history.woloo_details
        nameLabel.text = detail.name
        addressLabel.text = detail.address
        
        if detail.user_rating != "0" {
            starLabel.text = detail.user_rating ?? "0"
        }
        else{
            starLabel.text = String(3.0)
        }
       
        if history.type?.lowercased() == "cr" {
            lblEarnedPoints.text = "You have earned \(history.amount ?? "0") points"
            lblEarnedPoints.isHidden = false
        } else
        {
            lblEarnedPoints.isHidden = true
        }
        if (history.is_review_pending == 1) {
            rateButton.isHidden = false
        } else {
            rateButton.isHidden = true
        }
        if let isWashroom = detail.is_washroom, isWashroom == 1 {
            toilet.isHidden = false
        }
        if let isWheelchairAccessible = detail.is_wheelchair_accessible, isWheelchairAccessible == 1 {
            wheelChair.isHidden = false
        }
        if let isFeedingRoom = detail.is_feeding_room, isFeedingRoom == 1 {
            feeding.isHidden = false
        }
        if let isSanitizerAvailable = detail.is_sanitizer_available, isSanitizerAvailable == 1 {
            senitizer.isHidden = false
        }
        if let isCoffeeAvailable = detail.is_coffee_available, isCoffeeAvailable == 1 {
            coffee.isHidden = false
        }
        if let isMakeupRoomAvailable = detail.is_makeup_room_available, isMakeupRoomAvailable == 1 {
            makeup.isHidden = false
        }
        if let isSanitaryPadsAvailable = detail.is_sanitary_pads_available, isSanitaryPadsAvailable == 1 {
            diaper.isHidden = false
        }
        
        if let isCleanAndHygiene = detail.is_clean_and_hygiene, isCleanAndHygiene == 1 {
            clean.isHidden = false
        }
        if let isSafeSpace = detail.is_safe_space, isSafeSpace == 1 {
            safeSpace.isHidden = false
        }
        if let isCovidFree = detail.is_covid_free, isCovidFree == 1 {
            covidFree.isHidden = false
        }
        
        if let isPremium = detail.is_premium, isPremium == 0 {
            premiumLabel.isHidden = true
        }
        
        if let images = detail.image , images.count > 0 {
            let imageUrl = images.first
            if imageUrl?.count ?? 0 > 0 {
                let url = "https://staging-api.woloo.in/\(imageUrl ?? "")"
                print("imgUrl: ", url ?? "")
                self.bgImageView.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
//        if let offer = detail.offer,let image = offer.image {
//            if image.isValidUrl() {
//                bgImageView.setImage(string: image)
//            }
//        }
    }
    func fillOfferDetail(_ detail: WolooStore) {
        nameLabel.text = detail.name
        addressLabel.text = detail.address
        starLabel.text = detail.rating
        lblEarnedPoints.isHidden = true
        rateButton.isHidden = true
        if let isWashroom = detail.isWashroom, isWashroom == 1 {
            toilet.isHidden = false
        }
        if let isWheelchairAccessible = detail.isWheelchairAccessible, isWheelchairAccessible == 1 {
            wheelChair.isHidden = false
        }
        if let isFeedingRoom = detail.isFeedingRoom, isFeedingRoom == 1 {
            feeding.isHidden = false
        }
        if let isSanitizerAvailable = detail.isSanitizerAvailable, isSanitizerAvailable == 1 {
            senitizer.isHidden = false
        }
        if let isCoffeeAvailable = detail.isCoffeeAvailable, isCoffeeAvailable == 1 {
            coffee.isHidden = false
        }
        if let isMakeupRoomAvailable = detail.isMakeupRoomAvailable, isMakeupRoomAvailable == 1 {
            makeup.isHidden = false
        }
        if let isSanitaryPadsAvailable = detail.isSanitaryPadsAvailable, isSanitaryPadsAvailable == 1 {
            diaper.isHidden = false
        }
        
        if let isCleanAndHygiene = detail.isCleanAndHygiene, isCleanAndHygiene == 1 {
            clean.isHidden = false
        }
        if let isSafeSpace = detail.isSafeSpace, isSafeSpace == 1 {
            safeSpace.isHidden = false
        }
        if let isCovidFree = detail.isCovidFree, isCovidFree == 1 {
            covidFree.isHidden = false
        }
        
        if let isPremium = detail.isPremium, isPremium == 0 {
            premiumLabel.isHidden = true
        }
        
        /*if let images = detail.image , images.count > 0 {
            let imageUrl = images.first
            if imageUrl?.count ?? 0 > 0 {
                let url = "\(API.environment.baseURL)/storage/app/public/\(imageUrl ?? "")"
                self.bgImageView.sd_setImage(with: URL(string: url), completed: nil)
            }
        } */
        if let offer = detail.offer,let image = offer.image {
            let url = "\(API.environment.baseURL)/storage/app/public/\(image ?? "")"
            self.bgImageView.sd_setImage(with: URL(string: url), completed: nil)
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
