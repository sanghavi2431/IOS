//
//  SearchStoreCell.swift
//  Woloo
//
//  Created by ideveloper1 on 23/04/21.
//

import UIKit

class SearchStoreCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
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
    
    var store: WolooStore? {
        didSet {
            setData(store)
        }
    }
    
    var customStore: NearbyResultsModel?{
        
        didSet {
            customSetData(customStore)
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.cornerRadius = 8
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.warmGrey.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ store: WolooStore?) {
        guard let wolooStore = store else { return }
        
        nameLabel.text = wolooStore.name
        addressLabel.text = wolooStore.address
        starLabel.text = wolooStore.rating
        timeLabel.text = wolooStore.duration ?? ""
        distanceLabel.text = wolooStore.distance ?? ""
        
        /*
        if store?.duration == "-" {
            timeLabel.text = "-"
        } else {
            let dur = Int(wolooStore.duration ?? "0") ?? 0
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: dur)//wolooStore.duration ?? 0
            
            timeLabel.text = ""
            if h > 0 {
                timeLabel.text = "\(h)h "
            }
            if m > 0 {
                timeLabel.text = "\(timeLabel.text ?? "")\(m) min"
            }
            if timeLabel.text == "" {
                timeLabel.text = "0 min"
            }
        }
        
        if let distance = wolooStore.distance{
            if store?.distance == "-" {
                distanceLabel.text = distance
            } else {
                distanceLabel.text = String(format: "%.2fkm", distance.toDouble() ?? 0.00)
            }
        }
         */
        
        if let isWashroom = wolooStore.isWashroom, isWashroom == 1 {
            toilet.isHidden = false
        }
        if let isWheelchairAccessible = wolooStore.isWheelchairAccessible, isWheelchairAccessible == 1 {
            wheelChair.isHidden = false
        }
        if let isFeedingRoom = wolooStore.isFeedingRoom, isFeedingRoom == 1 {
            feeding.isHidden = false
        }
        if let isSanitizerAvailable = wolooStore.isSanitizerAvailable, isSanitizerAvailable == 1 {
            senitizer.isHidden = false
        }
        if let isCoffeeAvailable = wolooStore.isCoffeeAvailable, isCoffeeAvailable == 1 {
            coffee.isHidden = false
        }
        if let isMakeupRoomAvailable = wolooStore.isMakeupRoomAvailable, isMakeupRoomAvailable == 1 {
            makeup.isHidden = false
        }
        if let isSanitaryPadsAvailable = wolooStore.isSanitaryPadsAvailable, isSanitaryPadsAvailable == 1 {
            diaper.isHidden = false
        }
        if let isCleanAndHygiene = wolooStore.isCleanAndHygiene, isCleanAndHygiene == 1 {
            clean.isHidden = false
        }
        if let isSafeSpace = wolooStore.isSafeSpace, isSafeSpace == 1 {
            safeSpace.isHidden = false
        }
        if let isCovidFree = wolooStore.isCovidFree, isCovidFree == 1 {
            covidFree.isHidden = false
        }
        
        if let image = wolooStore.offer?.image {
            let url = "\(API.environment.baseURL)/storage/app/public/\(image)"
            self.bgImageView.isHidden = false
            self.bgImageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            self.bgImageView.isHidden = true
        }
    }
    
    func customSetData(_ customStore: NearbyResultsModel?){
        
        guard let customwolooStore = customStore else { return }

        nameLabel.text = customwolooStore.name
        addressLabel.text = customwolooStore.address
        distanceLabel.text = customwolooStore.distance ?? ""
        starLabel.text = "3.0"
        let timeDuration = customwolooStore.duration ?? ""
        
        
        timeLabel.text = "\(timeDuration ?? "")"
        print("Timer \(timeDuration ?? "")")
        //lblTimeUnit.text = "Min"
        
        if let isWashroom = customwolooStore.is_washroom, isWashroom == 1 {
            toilet.isHidden = false
        }
        if let isWheelchairAccessible = customwolooStore.is_wheelchair_accessible, isWheelchairAccessible == 1 {
            wheelChair.isHidden = false
        }
        if let isFeedingRoom = customwolooStore.is_feeding_room, isFeedingRoom == 1 {
            feeding.isHidden = false
        }
        if let isSanitizerAvailable = customwolooStore.is_sanitizer_available, isSanitizerAvailable == 1 {
            senitizer.isHidden = false
        }
        if let isCoffeeAvailable = customwolooStore.is_coffee_available, isCoffeeAvailable == 1 {
            coffee.isHidden = false
        }
        if let isMakeupRoomAvailable = customwolooStore.is_makeup_room_available, isMakeupRoomAvailable == 1 {
            makeup.isHidden = false
        }
        if let isSanitaryPadsAvailable = customwolooStore.is_sanitizer_available, isSanitaryPadsAvailable == 1 {
            diaper.isHidden = false
        }
        if let isCleanAndHygiene = customwolooStore.is_clean_and_hygiene, isCleanAndHygiene == 1 {
            clean.isHidden = false
        }
        if let isSafeSpace = customwolooStore.is_safe_space, isSafeSpace == 1 {
            safeSpace.isHidden = false
        }
        if let isCovidFree = customwolooStore.is_covid_free, isCovidFree == 1 {
            covidFree.isHidden = false
        }
        
        print("Image Array: \(customwolooStore.image?.count)")
        
        if customwolooStore.image?.count == 0{
            self.bgImageView.isHidden = true
            
        }else{
            let url = "\(customwolooStore.base_url ?? "")/\(customwolooStore.image?[0] ?? "")"
            //https://api.woloo.in//Images/WolooHost/1700295197_p115.jpg
            print("Image Url: \(customwolooStore.base_url ?? "")/\(customwolooStore.image?[0] ?? "")")
           // let url = "https://admin.woloo.in/storage/app/public/woloos/1676620412.jpg"
            self.bgImageView.isHidden = false
            self.bgImageView.sd_setImage(with: URL(string: url), completed: nil)
            
        }
        
       // if let image = customwolooStore.image?[0]{
           
       // } else {
//            self.bgImageView.isHidden = true
//        }
        
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
